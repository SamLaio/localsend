import 'dart:async';

import 'package:localsend_app/model/cross_file.dart';
import 'package:localsend_isolates/isolate.dart';
import 'package:localsend_isolates/rust/api/send_server.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';

final _logger = Logger('SendServerUpload');

final sendServerUploadProvider = NotifierProvider<SendServerUploadService, SendServerUploadState>((ref) {
  return SendServerUploadService();
});

enum SendServerUploadStatus {
  idle,
  loadingConfig,
  ready,
  uploading,
  finished,
  failed,
}

class SendServerUploadState {
  final SendServerUploadStatus status;
  final SendServerConfig? config;
  final int? taskId;
  final int sent;
  final int total;
  final double progress;
  final String? url;
  final String? password;
  final String? error;

  const SendServerUploadState({
    required this.status,
    required this.config,
    required this.taskId,
    required this.sent,
    required this.total,
    required this.progress,
    required this.url,
    required this.password,
    required this.error,
  });

  const SendServerUploadState.idle()
    : status = SendServerUploadStatus.idle,
      config = null,
      taskId = null,
      sent = 0,
      total = 0,
      progress = 0,
      url = null,
      password = null,
      error = null;

  SendServerUploadState copyWith({
    SendServerUploadStatus? status,
    SendServerConfig? config,
    int? taskId,
    int? sent,
    int? total,
    double? progress,
    String? url,
    String? password,
    String? error,
    bool clearTaskId = false,
    bool clearConfig = false,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return SendServerUploadState(
      status: status ?? this.status,
      config: clearConfig ? null : config ?? this.config,
      taskId: clearTaskId ? null : taskId ?? this.taskId,
      sent: sent ?? this.sent,
      total: total ?? this.total,
      progress: progress ?? this.progress,
      url: clearResult ? null : url ?? this.url,
      password: clearResult ? null : password ?? this.password,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class SendServerUploadService extends Notifier<SendServerUploadState> {
  StreamSubscription<SendServerUploadEvent>? _subscription;

  @override
  SendServerUploadState init() {
    return const SendServerUploadState.idle();
  }

  @override
  String describeState(SendServerUploadState state) {
    return 'SendServerUploadState(status: ${state.status}, progress: ${state.progress}, hasResult: ${state.url != null}, error: ${state.error})';
  }

  @override
  void dispose() {
    final taskId = state.taskId;
    if (taskId != null) {
      ref.redux(parentIsolateProvider).dispatch(IsolateSendServerUploadCancelAction(taskId: taskId));
    }
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  Future<void> loadConfig(String serverUrl) async {
    await _subscription?.cancel();
    state = state.copyWith(
      status: SendServerUploadStatus.loadingConfig,
      clearTaskId: true,
      clearConfig: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final result = ref.redux(parentIsolateProvider).dispatchTakeResult(IsolateSendServerFetchConfigAction(serverUrl: serverUrl));
      _subscription = result.events.listen(
        (event) {
          switch (event) {
            case SendServerConfigLoadedEvent(:final config):
              state = state.copyWith(status: SendServerUploadStatus.ready, config: config, clearTaskId: true, clearError: true);
            case SendServerUploadFailedEvent(:final error):
              state = state.copyWith(status: SendServerUploadStatus.failed, error: error, clearTaskId: true);
            case SendServerUploadProgressEvent():
            case SendServerUploadFinishedEvent():
              break;
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          _logger.warning('Send Server config stream failed', error, stackTrace);
          state = state.copyWith(status: SendServerUploadStatus.failed, error: error.toString(), clearTaskId: true);
        },
      );
    } catch (e, s) {
      _logger.warning('Could not load Send Server config', e, s);
      state = state.copyWith(status: SendServerUploadStatus.failed, error: e.toString(), clearTaskId: true);
    }
  }

  Future<void> upload({
    required String serverUrl,
    required String? password,
    required String? uploadAuthPassword,
    required int downloadLimit,
    required int expireSeconds,
    required List<CrossFile> files,
  }) async {
    await _subscription?.cancel();
    state = state.copyWith(
      status: SendServerUploadStatus.uploading,
      sent: 0,
      total: _encryptedTotal(files),
      progress: 0,
      clearTaskId: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final result = ref
          .redux(parentIsolateProvider)
          .dispatchTakeResult(
            IsolateSendServerUploadFilesAction(
              serverUrl: serverUrl,
              password: password,
              uploadAuthPassword: uploadAuthPassword,
              downloadLimit: downloadLimit,
              expireSeconds: expireSeconds,
              files: files
                  .map(
                    (file) => SendServerUploadFile(
                      name: file.name,
                      filePath: file.path,
                      fileBytes: file.bytes,
                      fileSize: file.size,
                    ),
                  )
                  .toList(),
            ),
          );
      state = state.copyWith(taskId: result.taskId);
      _subscription = result.events.listen(
        (event) {
          switch (event) {
            case SendServerUploadProgressEvent(:final sent, :final total, :final progress):
              state = state.copyWith(sent: sent, total: total, progress: progress);
            case SendServerUploadFinishedEvent(:final url, :final password):
              state = state.copyWith(
                status: SendServerUploadStatus.finished,
                url: url,
                password: password,
                progress: 1,
                clearTaskId: true,
              );
            case SendServerUploadFailedEvent(:final error):
              state = state.copyWith(status: SendServerUploadStatus.failed, error: error, clearTaskId: true);
            case SendServerConfigLoadedEvent():
              break;
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          _logger.warning('Send Server upload stream failed', error, stackTrace);
          state = state.copyWith(status: SendServerUploadStatus.failed, error: error.toString(), clearTaskId: true);
        },
      );
    } catch (e, s) {
      _logger.warning('Could not upload to Send Server', e, s);
      state = state.copyWith(status: SendServerUploadStatus.failed, error: e.toString(), clearTaskId: true);
    }
  }

  Future<void> cancel() async {
    final taskId = state.taskId;
    if (taskId != null) {
      ref.redux(parentIsolateProvider).dispatch(IsolateSendServerUploadCancelAction(taskId: taskId));
    }
    await _subscription?.cancel();
    _subscription = null;
    if (state.status == SendServerUploadStatus.uploading || state.status == SendServerUploadStatus.loadingConfig) {
      state = state.copyWith(status: SendServerUploadStatus.idle, clearTaskId: true);
    }
  }
}

int _encryptedTotal(List<CrossFile> files) {
  final plain = files.fold<int>(0, (prev, file) => prev + file.size);
  return encryptedUploadSize(size: BigInt.from(plain)).toInt();
}
