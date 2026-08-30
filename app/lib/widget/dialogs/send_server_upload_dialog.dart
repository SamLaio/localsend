import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localsend_app/config/theme.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/cross_file.dart';
import 'package:localsend_app/provider/send_server/send_server_upload_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/util/native/channel/android_channel.dart' as android_channel;
import 'package:localsend_app/util/ui/snackbar.dart';
import 'package:localsend_isolates/rust/api/send_server.dart';
import 'package:localsend_isolates/util/file_size_helper.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

const _defaultDownloadCounts = [1, 2, 3, 5, 10, 20, 50, 100];
const _defaultExpireSeconds = [300, 3600, 86400, 604800, 2592000];

class SendServerUploadDialog extends StatefulWidget {
  final List<CrossFile> files;

  const SendServerUploadDialog({
    required this.files,
  });

  static Future<void> open({
    required BuildContext context,
    required List<CrossFile> files,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SendServerUploadDialog(files: files),
    );
  }

  @override
  State<SendServerUploadDialog> createState() => _SendServerUploadDialogState();
}

class _SendServerUploadDialogState extends State<SendServerUploadDialog> with Refena {
  late final TextEditingController _passwordController;
  late final String _serverUrl;

  int _downloadLimit = 1;
  int _expireSeconds = 300;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _serverUrl = settings.sendServerUrl.trim();
    _passwordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(ref.notifier(sendServerUploadProvider).loadConfig(_serverUrl));
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sendServerUploadProvider);
    final config = state.config;
    final downloadCounts = _downloadCounts(config);
    final expireSecondsOptions = _expireSecondsOptions(config);
    _downloadLimit = _clampOption(_downloadLimit, downloadCounts);
    _expireSeconds = _clampOption(_expireSeconds, expireSecondsOptions);

    final selectedBytes = widget.files.fold<int>(0, (prev, file) => prev + file.size);
    final maxSize = config?.limits.anon.maxFileSize.toInt();
    final sizeTooLarge = maxSize != null && selectedBytes > maxSize;
    final uploading = state.status == SendServerUploadStatus.uploading;
    final finished = state.status == SendServerUploadStatus.finished;
    final loadingConfig = state.status == SendServerUploadStatus.loadingConfig;
    final uploadAuthRequired = config?.uploadAuth?.required ?? false;
    final uploadAuthPassword = ref.watch(settingsProvider).sendServerUploadAuthPassword;
    final uploadAuthMissing = uploadAuthRequired && (uploadAuthPassword == null || uploadAuthPassword.isEmpty);
    final canUpload = !uploading && !loadingConfig && !finished && !sizeTooLarge && config != null && _serverUrl.isNotEmpty && !uploadAuthMissing;

    return PopScope(
      canPop: !uploading,
      child: AlertDialog(
        title: Text(t.dialogs.sendServerUpload.title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.dialogs.sendServerUpload.selectedFiles(files: widget.files.length, size: selectedBytes.asReadableFileSize),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (maxSize != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      t.dialogs.sendServerUpload.anonymousLimit(size: maxSize.asReadableFileSize),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                if (sizeTooLarge)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      t.dialogs.sendServerUpload.sizeTooLarge,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                if (_serverUrl.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      t.dialogs.sendServerUpload.missingUrl,
                      style: TextStyle(color: Theme.of(context).colorScheme.warning),
                    ),
                  ),
                if (uploadAuthMissing)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      t.dialogs.sendServerUpload.missingUploadAuthPassword,
                      style: TextStyle(color: Theme.of(context).colorScheme.warning),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  enabled: !uploading && !finished,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t.dialogs.sendServerUpload.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _downloadLimit,
                  decoration: InputDecoration(labelText: t.dialogs.sendServerUpload.downloadLimit),
                  items: downloadCounts.map((value) => DropdownMenuItem(value: value, child: Text('$value'))).toList(),
                  onChanged: uploading || finished ? null : (value) => setState(() => _downloadLimit = value ?? _downloadLimit),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _expireSeconds,
                  decoration: InputDecoration(labelText: t.dialogs.sendServerUpload.expireTime),
                  items: expireSecondsOptions.map((value) => DropdownMenuItem(value: value, child: Text(_formatExpire(value)))).toList(),
                  onChanged: uploading || finished ? null : (value) => setState(() => _expireSeconds = value ?? _expireSeconds),
                ),
                if (loadingConfig)
                  const Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: LinearProgressIndicator(),
                  ),
                if (uploading) ...[
                  const SizedBox(height: 18),
                  LinearProgressIndicator(value: state.progress == 0 ? null : state.progress),
                  const SizedBox(height: 8),
                  Text('${state.sent.asReadableFileSize} / ${state.total.asReadableFileSize}'),
                ],
                if (state.error != null) ...[
                  const SizedBox(height: 14),
                  Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                if (finished && state.url != null) ...[
                  const SizedBox(height: 18),
                  SelectableText(state.url!),
                  if (state.password != null && state.password!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SelectableText(t.dialogs.sendServerUpload.passwordResult(password: state.password!)),
                  ],
                ],
              ],
            ),
          ),
        ),
        actions: [
          if (uploading)
            TextButton(
              onPressed: () async => await ref.notifier(sendServerUploadProvider).cancel(),
              child: Text(t.general.cancel),
            )
          else
            TextButton(
              onPressed: () async {
                await ref.notifier(sendServerUploadProvider).cancel();
                if (context.mounted) {
                  context.pop();
                }
              },
              child: Text(finished ? t.general.close : t.general.cancel),
            ),
          if (finished && state.url != null) ...[
            TextButton.icon(
              onPressed: () async => await _copyResult(state),
              icon: const Icon(Icons.copy),
              label: Text(t.general.copy),
            ),
            ElevatedButton.icon(
              onPressed: defaultTargetPlatform == TargetPlatform.android
                  ? () async => await android_channel.shareTextAndroid(text: _shareText(state))
                  : null,
              icon: const Icon(Icons.share),
              label: Text(t.dialogs.sendServerUpload.share),
            ),
          ] else
            ElevatedButton.icon(
              onPressed: canUpload
                  ? () async {
                      await ref
                          .notifier(sendServerUploadProvider)
                          .upload(
                            serverUrl: _serverUrl,
                            password: _passwordController.text.trim().isEmpty ? null : _passwordController.text,
                            uploadAuthPassword: uploadAuthPassword,
                            downloadLimit: _downloadLimit,
                            expireSeconds: _expireSeconds,
                            files: widget.files,
                          );
                    }
                  : null,
              icon: const Icon(Icons.cloud_upload_outlined),
              label: Text(t.dialogs.sendServerUpload.upload),
            ),
        ],
      ),
    );
  }

  Future<void> _copyResult(SendServerUploadState state) async {
    await Clipboard.setData(ClipboardData(text: _shareText(state)));
    if (mounted) {
      context.showSnackBar(t.general.copiedToClipboard);
    }
  }

  String _shareText(SendServerUploadState state) {
    final password = state.password;
    if (password == null || password.isEmpty) {
      return state.url ?? '';
    }
    return '${state.url}\n${t.dialogs.sendServerUpload.passwordResult(password: password)}';
  }
}

List<int> _downloadCounts(SendServerConfig? config) {
  final maxDownloads = config?.limits.anon.maxDownloads.toInt();
  final values = maxDownloads == null
      ? null
      : config?.defaults.downloadCounts.map((value) => value.toInt()).where((value) => value <= maxDownloads).toList();
  if (values != null && values.isNotEmpty) {
    return values;
  }
  return _defaultDownloadCounts;
}

List<int> _expireSecondsOptions(SendServerConfig? config) {
  final maxExpireSeconds = config?.limits.anon.maxExpireSeconds.toInt();
  final values = maxExpireSeconds == null
      ? null
      : config?.defaults.expireTimesSeconds.map((value) => value.toInt()).where((value) => value <= maxExpireSeconds).toList();
  if (values != null && values.isNotEmpty) {
    return values;
  }
  return _defaultExpireSeconds;
}

int _clampOption(int current, List<int> options) {
  if (options.contains(current)) {
    return current;
  }
  return options.first;
}

String _formatExpire(int seconds) {
  if (seconds < 3600) {
    return '${seconds ~/ 60} 分鐘';
  }
  if (seconds < 86400) {
    return '${seconds ~/ 3600} 小時';
  }
  final days = seconds ~/ 86400;
  if (days < 30) {
    return '$days 天';
  }
  final months = days ~/ 30;
  if (months < 12) {
    return '$months 個月';
  }
  final years = days ~/ 365;
  return '$years 年';
}
