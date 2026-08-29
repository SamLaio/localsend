import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:localsend_isolates/rust/api/cancel.dart';
import 'package:localsend_isolates/rust/api/send_server.dart';
import 'package:localsend_isolates/src/isolate/child/main.dart';
import 'package:localsend_isolates/src/isolate/child/sync_provider.dart';
import 'package:localsend_isolates/src/isolate/dto/send_to_isolate_data.dart';
import 'package:localsend_isolates/util/android_channel.dart';
import 'package:localsend_isolates/util/rust.dart';
import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:typed_isolates/typed_isolates.dart';

sealed class BaseSendServerUploadTask {}

class SendServerUploadFile {
  final String name;
  final String? filePath;
  final List<int>? fileBytes;
  final int fileSize;

  SendServerUploadFile({
    required this.name,
    required this.filePath,
    required this.fileBytes,
    required this.fileSize,
  });
}

class SendServerFetchConfigTask implements BaseSendServerUploadTask {
  final String serverUrl;

  SendServerFetchConfigTask({
    required this.serverUrl,
  });
}

class SendServerUploadFilesTask implements BaseSendServerUploadTask {
  final String serverUrl;
  final String? password;
  final int downloadLimit;
  final int expireSeconds;
  final List<SendServerUploadFile> files;

  SendServerUploadFilesTask({
    required this.serverUrl,
    required this.password,
    required this.downloadLimit,
    required this.expireSeconds,
    required this.files,
  });
}

class SendServerUploadCancelTask implements BaseSendServerUploadTask {
  final int taskId;

  SendServerUploadCancelTask({required this.taskId});
}

sealed class SendServerUploadEvent {}

class SendServerConfigLoadedEvent extends SendServerUploadEvent {
  final SendServerConfig config;

  SendServerConfigLoadedEvent({required this.config});
}

class SendServerUploadProgressEvent extends SendServerUploadEvent {
  final int sent;
  final int total;
  final double progress;

  SendServerUploadProgressEvent({
    required this.sent,
    required this.total,
    required this.progress,
  });
}

class SendServerUploadFinishedEvent extends SendServerUploadEvent {
  final String id;
  final String url;
  final String? password;

  SendServerUploadFinishedEvent({
    required this.id,
    required this.url,
    required this.password,
  });
}

class SendServerUploadFailedEvent extends SendServerUploadEvent {
  final String error;

  SendServerUploadFailedEvent({required this.error});
}

final _cancelTokenProvider = Provider((ref) => <int, RsCancellationToken>{});
final _logger = Logger('SendServerUploadIsolate');

Future<void> setupSendServerUploadIsolate(
  Stream<SendToIsolateData<IsolateTask<BaseSendServerUploadTask>>> receiveFromMain,
  void Function(IsolateTaskStreamResult<SendServerUploadEvent>) sendToMain,
  InitialData initialData,
) async {
  await setupChildIsolateHelper(
    debugLabel: 'SendServerUploadIsolate',
    receiveFromMain: receiveFromMain,
    sendToMain: sendToMain,
    initialData: initialData,
    init: (ref) async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(
        ref.read(syncProvider).rootIsolateToken as RootIsolateToken,
      );
    },
    handler: (ref, task) async {
      switch (task.data) {
        case SendServerFetchConfigTask taskData:
          await _fetchConfig(task.id, taskData, sendToMain);
        case SendServerUploadFilesTask taskData:
          await _upload(task.id, taskData, ref, sendToMain);
        case SendServerUploadCancelTask taskData:
          final cancelToken = ref.read(_cancelTokenProvider).remove(taskData.taskId);
          cancelToken?.cancel();
      }
    },
  );
}

Future<void> _fetchConfig(
  int taskId,
  SendServerFetchConfigTask task,
  void Function(IsolateTaskStreamResult<SendServerUploadEvent>) sendToMain,
) async {
  try {
    final config = await fetchSendServerConfig(serverUrl: task.serverUrl);
    sendToMain(IsolateTaskStreamResult.event(id: taskId, data: SendServerConfigLoadedEvent(config: config)));
  } catch (e) {
    sendToMain(IsolateTaskStreamResult.event(id: taskId, data: SendServerUploadFailedEvent(error: e.humanSendServerErrorMessage)));
  } finally {
    sendToMain(IsolateTaskStreamResult.done(id: taskId));
  }
}

Future<void> _upload(
  int taskId,
  SendServerUploadFilesTask task,
  Ref ref,
  void Function(IsolateTaskStreamResult<SendServerUploadEvent>) sendToMain,
) async {
  final cancelToken = createCancellationToken();
  ref.read(_cancelTokenProvider)[taskId] = cancelToken;
  try {
    final files = <RsSendServerFile>[];
    for (final file in task.files) {
      final filePath = file.filePath;
      final isContentUri = filePath?.startsWith('content://') ?? false;
      files.add(
        RsSendServerFile(
          name: file.name,
          size: BigInt.from(file.fileSize),
          mime: lookupMimeType(file.name) ?? 'application/octet-stream',
          filePath: !isContentUri ? filePath : null,
          fileBytes: file.fileBytes == null ? null : Uint8List.fromList(file.fileBytes!),
          fileDescriptor: isContentUri ? await getFileDescriptorAndroid(uri: filePath!) : null,
        ),
      );
    }

    await for (final event in uploadSendServer(
      files: files,
      options: RsSendServerUploadOptions(
        serverUrl: task.serverUrl,
        password: task.password,
        downloadLimit: BigInt.from(task.downloadLimit),
        expireSeconds: BigInt.from(task.expireSeconds),
      ),
      cancelToken: cancelToken,
    )) {
      switch (event) {
        case RsSendServerUploadEvent_Progress(:final sent, :final total, :final progress):
          sendToMain(
            IsolateTaskStreamResult.event(
              id: taskId,
              data: SendServerUploadProgressEvent(sent: sent.toInt(), total: total.toInt(), progress: progress),
            ),
          );
        case RsSendServerUploadEvent_Finished(:final id, :final url, :final password):
          sendToMain(IsolateTaskStreamResult.event(id: taskId, data: SendServerUploadFinishedEvent(id: id, url: url, password: password)));
        case RsSendServerUploadEvent_Failed(:final error):
          sendToMain(IsolateTaskStreamResult.event(id: taskId, data: SendServerUploadFailedEvent(error: error.humanSendServerErrorMessage)));
      }
    }
  } catch (e, st) {
    _logger.warning('Send Server upload failed', e, st);
    sendToMain(IsolateTaskStreamResult.event(id: taskId, data: SendServerUploadFailedEvent(error: e.humanSendServerErrorMessage)));
  } finally {
    ref.read(_cancelTokenProvider).remove(taskId);
    sendToMain(IsolateTaskStreamResult.done(id: taskId));
  }
}

extension SendServerErrorMessageExt on Object {
  String get humanSendServerErrorMessage {
    final e = this;
    return switch (e) {
      RsSendServerError_InvalidUrl() => 'Invalid Send Server URL',
      RsSendServerError_Status(:final status) => 'Send Server returned HTTP $status',
      RsSendServerError_InvalidResponse(:final field0) => field0,
      RsSendServerError_Network(:final field0) => field0,
      RsSendServerError_Io(:final field0) => field0,
      RsSendServerError_Cancelled() => 'Upload cancelled',
      RsSendServerError_Crypto() => 'Crypto error',
      RsSendServerError_Other(:final field0) => field0,
      _ => e.humanErrorMessage,
    };
  }
}
