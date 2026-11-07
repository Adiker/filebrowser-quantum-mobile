import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

import '../data/preferences_store.dart';
import 'update_service.dart';

class UpdateController extends ChangeNotifier with WidgetsBindingObserver {
  UpdateController(this.prefs,
      {UpdateService? service,
      Future<String> Function()? version,
      bool? android,
      DateTime Function()? clock,
      bool start = true})
      : service = service ?? UpdateService(),
        _version = version ?? _installedVersion,
        _android = android ?? Platform.isAndroid,
        _clock = clock ?? DateTime.now {
    _initialization = start ? _loadVersion() : Future.value();
    WidgetsBinding.instance.addObserver(this);
    if (start) unawaited(_startAutomaticCheck());
  }
  late final Future<void> _initialization;
  Future<void> get initialized => _initialization;
  final PreferencesStore prefs;
  final UpdateService service;
  final Future<String> Function() _version;
  final bool _android;
  final DateTime Function() _clock;
  static Future<String> _installedVersion() async =>
      (await PackageInfo.fromPlatform()).version;
  static const _channel =
      MethodChannel('com.adiker.filebrowser_quantum_mobile/update');
  UpdateRelease? release;
  String currentVersion = '';
  String? error;
  bool checking = false;
  bool checked = false;
  bool dismissed = false;
  bool downloading = false;
  bool permissionRequired = false;
  double progress = 0;
  File? apk;
  bool _disposed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(checkAutomatic());
  }

  Future<void> _startAutomaticCheck() async {
    await _initialization;
    if (!_disposed) await checkAutomatic();
  }

  Future<void> _loadVersion() async {
    try {
      currentVersion = await _version();
      final target = prefs.downloadedUpdateVersion;
      if (target != null &&
          Version.parse(currentVersion) >= Version.parse(target)) {
        // Keep the marker if cleanup fails so the next launch can retry.
        await service.clearDownloads();
        await prefs.setDownloadedUpdateVersion(null);
      }
      _notify();
    } catch (_) {
      // Keep the marker and retry on the next launch if lookup or cleanup fails.
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> setAutomatic(bool enabled) async {
    await prefs.setAutoUpdateChecks(enabled);
    _notify();
    if (enabled) await checkAutomatic();
  }

  Future<void> checkAutomatic() async {
    if (!_android || !prefs.autoUpdateChecks || checking) return;
    final last = prefs.lastUpdateCheck;
    final now = _clock();
    if (last != null &&
        now.difference(last) < const Duration(hours: 24) &&
        !now.isBefore(last)) {
      return;
    }
    await check(manual: false);
  }

  Future<void> check({bool manual = true}) async {
    await _initialization;
    if (_disposed || checking || downloading) return;
    checking = true;
    error = null;
    if (manual) dismissed = false;
    _notify();
    try {
      await prefs.setLastUpdateCheck(_clock());
      currentVersion = await _version();
      final found = await service.check(currentVersion);
      if (release?.version != found?.version) {
        apk = null;
        try {
          await service.clearDownloads();
        } catch (_) {/* Download will retry cleanup. */}
      }
      release = found;
      dismissed = manual;
      checked = true;
    } catch (e) {
      if (manual) {
        error = e.toString();
        checked = true;
      }
    } finally {
      checking = false;
      _notify();
    }
  }

  void dismiss() {
    dismissed = true;
    _notify();
  }

  void cancelDownload() => service.cancel();

  Future<void> download() async {
    await _initialization;
    if (_disposed) return;
    final target = release;
    if (target == null || downloading) return;
    downloading = true;
    error = null;
    progress = 0;
    apk = null;
    _notify();
    try {
      final downloaded = await service.download(target, (value) {
        progress = value;
        _notify();
      });
      await prefs.setDownloadedUpdateVersion(target.version.toString());
      apk = downloaded;
    } catch (e) {
      error = e.toString();
    } finally {
      downloading = false;
      _notify();
    }
    if (apk != null && !_disposed) await install();
  }

  Future<void> install() async {
    if (apk == null || release == null) return;
    error = null;
    try {
      final result = await _channel.invokeMethod<String>('install', {
        'path': apk!.path,
        'version': release!.version.toString(),
      });
      permissionRequired = result == 'permission';
    } catch (e) {
      error = e.toString();
      try {
        await apk?.delete();
      } catch (_) {/* It may already be gone. */}
      apk = null;
    }
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    service.dispose();
    super.dispose();
  }
}
