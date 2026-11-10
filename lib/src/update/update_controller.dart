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

  Future<void> _discardDownload() async {
    // Clear metadata first: a failed file deletion must not resurrect an
    // invalidated or superseded APK on a later launch.
    await prefs.setDownloadedUpdateRecord(null);
    await prefs.setDownloadedUpdateVersion(null);
    await service.clearDownloads();
  }

  Future<void> _loadVersion() async {
    try {
      currentVersion = await _version();
      final record = prefs.downloadedUpdateRecord;
      final legacy = prefs.downloadedUpdateVersion;
      UpdateRelease? saved;
      if (record != null) {
        try {
          saved = UpdateRelease.fromRecord(record);
        } catch (_) {
          await _discardDownload();
          _notify();
          return;
        }
      }
      Version? legacyVersion;
      if (legacy != null) {
        try {
          legacyVersion = Version.parse(legacy);
        } on FormatException {
          // An invalid legacy marker cannot identify a trusted download.
        }
      }
      final target = saved?.version ?? legacyVersion;
      if (target != null && Version.parse(currentVersion) >= target) {
        // Keep metadata if deletion fails so a later launch can retry.
        await service.clearDownloads();
        await prefs.setDownloadedUpdateRecord(null);
        await prefs.setDownloadedUpdateVersion(null);
      } else if (saved != null) {
        final file = await service.verifiedDownload(saved);
        if (file == null) {
          await _discardDownload();
        } else {
          release = saved;
          apk = file;
          checked = true;
        }
      } else {
        // Also removes partial downloads left behind by process termination.
        await _discardDownload();
      }
      _notify();
    } catch (_) {
      // Retry cleanup on the next launch if lookup or deletion fails.
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
      final previous = release;
      if (previous != null && (found == null || !previous.sameApk(found))) {
        apk = null;
        try {
          await _discardDownload();
        } catch (_) {/* Cleanup will be retried before a new download. */}
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
    if (target == null || downloading || checking) return;
    downloading = true;
    error = null;
    progress = 0;
    apk = null;
    _notify();
    try {
      await prefs.setDownloadedUpdateRecord(null);
      await prefs.setDownloadedUpdateVersion(null);
      final downloaded = await service.download(target, (value) {
        progress = value;
        _notify();
      });
      await prefs.setDownloadedUpdateRecord(target.toRecord());
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
    if (apk == null || release == null || checking || downloading) return;
    error = null;
    try {
      final result = await _channel.invokeMethod<String>('install', {
        'path': apk!.path,
        'version': release!.version.toString(),
      });
      permissionRequired = result == 'permission';
    } catch (e) {
      error = e.toString();
      apk = null;
      try {
        await _discardDownload();
      } catch (_) {/* Invalid metadata must not be restored on restart. */}
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
