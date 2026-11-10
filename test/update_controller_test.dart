import 'dart:io';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:filebrowser_mobile/l10n/app_localizations.dart';
import 'package:filebrowser_mobile/src/data/preferences_store.dart';
import 'package:filebrowser_mobile/src/ui/update_screen.dart';
import 'package:filebrowser_mobile/src/update/update_controller.dart';
import 'package:filebrowser_mobile/src/update/update_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FailingCleanupService extends UpdateService {
  @override
  Future<void> clearDownloads() async =>
      throw const FileSystemException('Cannot delete APK');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 11, 7);
  const response =
      '{"tag_name":"v0.5.0","draft":false,"prerelease":false,"body":"Changes","assets":[{"name":"filebrowser-mobile-v0.5.0.apk","state":"uploaded","size":8,"digest":"sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","browser_download_url":"https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk"}]}';

  test(
      'automatic checks are throttled and manual checks bypass disabled setting',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesStore.create();
    var calls = 0;
    final controller = UpdateController(prefs,
        start: false,
        android: true,
        clock: () => now,
        version: () async => '0.4.0',
        service: UpdateService(client: MockClient((_) async {
          calls++;
          return http.Response(response, 200);
        })));
    addTearDown(controller.dispose);
    await controller.checkAutomatic();
    expect(calls, 1);
    expect(controller.release!.version.toString(), '0.5.0');
    controller.dismiss();
    await controller.checkAutomatic();
    expect(calls, 1);
    expect(controller.dismissed, isTrue);
    await controller.setAutomatic(false);
    await controller.checkAutomatic();
    expect(calls, 1);
    await controller.check();
    expect(calls, 2);
    expect(controller.dismissed, isTrue);
    expect((await PreferencesStore.create()).autoUpdateChecks, isFalse);
  });

  testWidgets('manual check displays available release', (tester) async {
    SharedPreferences.setMockInitialValues({'auto_update_checks': false});
    final prefs = await PreferencesStore.create();
    final controller = UpdateController(prefs,
        start: false,
        version: () async => '0.4.0',
        service: UpdateService(
            client: MockClient((_) async => http.Response(response, 200))));
    addTearDown(controller.dispose);
    await tester.pumpWidget(ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: UpdateScreen(),
        )));
    await tester.runAsync(() async {
      await controller.check();
    });
    await tester.pumpAndSettle();
    expect(find.text('Update available: 0.5.0'), findsOneWidget);
    expect(find.text('Changes'), findsOneWidget);
    expect(find.text('Download update'), findsOneWidget);
  });

  test('installation can be retried after returning from permission settings',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesStore.create();
    final controller = UpdateController(prefs, start: false);
    addTearDown(controller.dispose);
    final dir = await Directory.systemTemp.createTemp();
    addTearDown(() => dir.delete(recursive: true));
    controller.apk = await File('${dir.path}/update.apk').writeAsString('apk');
    controller.release = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: '',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: 3,
        sha256: '');
    var calls = 0;
    const channel =
        MethodChannel('com.adiker.filebrowser_quantum_mobile/update');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'install');
      calls++;
      return calls == 1 ? 'permission' : 'launched';
    });
    addTearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));
    await controller.install();
    expect(controller.permissionRequired, isTrue);
    expect(await controller.apk!.exists(), isTrue);
    await controller.install();
    expect(controller.permissionRequired, isFalse);
    expect(calls, 2);
  });

  test('a verified download launches the installer', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesStore.create();
    final dir = await Directory.systemTemp.createTemp();
    addTearDown(() => dir.delete(recursive: true));
    final bytes = utf8.encode('apk data');
    final service = UpdateService(
        directory: () async => dir,
        downloadClient: () =>
            MockClient((_) async => http.Response.bytes(bytes, 200)));
    final controller = UpdateController(prefs, start: false, service: service);
    addTearDown(controller.dispose);
    controller.release = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: '',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: bytes.length,
        sha256: sha256.convert(bytes).toString());
    var calls = 0;
    const channel =
        MethodChannel('com.adiker.filebrowser_quantum_mobile/update');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      calls++;
      return 'launched';
    });
    addTearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));
    await controller.download();
    expect(calls, 1);
    expect(controller.apk, isNotNull);
    expect(
        UpdateRelease.fromRecord(prefs.downloadedUpdateRecord!)
            .version
            .toString(),
        '0.5.0');
    expect(controller.error, isNull);
  });

  test('removes downloaded APK after the installed version reaches its target',
      () async {
    for (final installed in ['0.5.0', '0.6.0']) {
      SharedPreferences.setMockInitialValues({
        'downloaded_update_version': '0.5.0',
        'auto_update_checks': false,
      });
      final prefs = await PreferencesStore.create();
      final dir = await Directory.systemTemp.createTemp();
      final updateDir = await Directory('${dir.path}/updates').create();
      final apk =
          await File('${updateDir.path}/update.apk').writeAsString('apk');
      final controller = UpdateController(prefs,
          android: false,
          version: () async => installed,
          service: UpdateService(directory: () async => dir));
      await controller.initialized;
      expect(await apk.exists(), isFalse);
      expect(prefs.downloadedUpdateVersion, isNull);
      controller.dispose();
      await dir.delete(recursive: true);
    }
  });

  test('legacy version-only marker and APK are discarded before installation',
      () async {
    SharedPreferences.setMockInitialValues({
      'downloaded_update_version': '0.5.0',
      'auto_update_checks': false,
    });
    final prefs = await PreferencesStore.create();
    final dir = await Directory.systemTemp.createTemp();
    final updateDir = await Directory('${dir.path}/updates').create();
    final apk = await File('${updateDir.path}/update.apk').writeAsString('apk');
    final controller = UpdateController(prefs,
        android: false,
        version: () async => '0.4.0',
        service: UpdateService(directory: () async => dir));
    await controller.initialized;
    expect(await apk.exists(), isFalse);
    expect(prefs.downloadedUpdateVersion, isNull);
    expect(controller.apk, isNull);
    controller.dispose();
    await dir.delete(recursive: true);
  });

  test('retains cleanup marker when deleting APK fails', () async {
    SharedPreferences.setMockInitialValues(
        {'downloaded_update_version': '0.5.0'});
    final prefs = await PreferencesStore.create();
    final controller = UpdateController(prefs,
        android: false,
        version: () async => '0.5.0',
        service: FailingCleanupService());
    await controller.initialized;
    expect(prefs.downloadedUpdateVersion, '0.5.0');
    controller.dispose();
  });

  test('verified APK survives restart and offline check, then can be installed',
      () async {
    SharedPreferences.setMockInitialValues({'auto_update_checks': false});
    final prefs = await PreferencesStore.create();
    final dir = await Directory.systemTemp.createTemp();
    addTearDown(() => dir.delete(recursive: true));
    final bytes = utf8.encode('apk data');
    final saved = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: 'Release notes',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: bytes.length,
        sha256: sha256.convert(bytes).toString());
    var calls = 0;
    const channel =
        MethodChannel('com.adiker.filebrowser_quantum_mobile/update');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      calls++;
      return 'launched';
    });
    addTearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null));
    final first = UpdateController(prefs,
        start: false,
        service: UpdateService(
            directory: () async => dir,
            downloadClient: () =>
                MockClient((_) async => http.Response.bytes(bytes, 200))));
    first.release = saved;
    await first.download();
    expect(calls, 1);
    first.dispose();
    final second = UpdateController(prefs,
        android: false,
        version: () async => '0.4.0',
        service: UpdateService(
            directory: () async => dir,
            client: MockClient(
                (_) async => throw const SocketException('offline'))));
    addTearDown(second.dispose);
    await second.initialized;
    expect(calls, 1, reason: 'restart must not launch installer');
    expect(second.release?.notes, 'Release notes');
    expect(second.apk, isNotNull);
    await second.check();
    expect(second.apk, isNotNull);
    await second.install();
    expect(calls, 2);
    expect(await second.apk!.readAsBytes(), bytes);
  });

  test(
      'same release retains restored APK; changed digest or newer release discards it',
      () async {
    final bytes = utf8.encode('apk data');
    final saved = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: 'Notes',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: bytes.length,
        sha256: sha256.convert(bytes).toString());
    for (final scenario in ['same', 'digest', 'newer']) {
      SharedPreferences.setMockInitialValues({
        'auto_update_checks': false,
        'downloaded_update_record': saved.toRecord()
      });
      final prefs = await PreferencesStore.create();
      final dir = await Directory.systemTemp.createTemp();
      final updateDir = await Directory('${dir.path}/updates').create();
      final file =
          await File('${updateDir.path}/update.apk').writeAsBytes(bytes);
      final record = jsonDecode(saved.toRecord()) as Map<String, dynamic>;
      final asset = (record['assets'] as List).single as Map<String, dynamic>;
      if (scenario == 'digest') asset['digest'] = 'sha256:${'a' * 64}';
      if (scenario == 'newer') {
        record['tag_name'] = 'v0.6.0';
        asset['name'] = 'filebrowser-mobile-v0.6.0.apk';
        asset['browser_download_url'] =
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.6.0/filebrowser-mobile-v0.6.0.apk';
      }
      final controller = UpdateController(prefs,
          android: false,
          version: () async => '0.4.0',
          service: UpdateService(
              directory: () async => dir,
              client: MockClient(
                  (_) async => http.Response(jsonEncode(record), 200))));
      await controller.initialized;
      expect(controller.apk, isNotNull);
      await controller.check();
      expect(controller.apk != null, scenario == 'same');
      expect(await file.exists(), scenario == 'same');
      expect(prefs.downloadedUpdateRecord != null, scenario == 'same');
      controller.dispose();
      await dir.delete(recursive: true);
    }
  });

  test('invalid, missing or interrupted APK is discarded at startup', () async {
    final bytes = utf8.encode('apk data');
    final saved = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: '',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: bytes.length,
        sha256: sha256.convert(bytes).toString());
    for (final scenario in ['missing', 'size', 'hash', 'metadata', 'partial']) {
      SharedPreferences.setMockInitialValues({
        'auto_update_checks': false,
        if (scenario != 'partial')
          'downloaded_update_record':
              scenario == 'metadata' ? '{"bad":true}' : saved.toRecord()
      });
      final prefs = await PreferencesStore.create();
      final dir = await Directory.systemTemp.createTemp();
      final updateDir = await Directory('${dir.path}/updates').create();
      final file = File('${updateDir.path}/update.apk');
      if (scenario != 'missing') {
        await file.writeAsBytes(
            scenario == 'hash' ? utf8.encode('bad data') : utf8.encode('bad'));
      }
      final controller = UpdateController(prefs,
          android: false,
          version: () async => '0.4.0',
          service: UpdateService(directory: () async => dir));
      await controller.initialized;
      expect(controller.apk, isNull, reason: scenario);
      expect(controller.release, isNull, reason: scenario);
      expect(prefs.downloadedUpdateRecord, isNull, reason: scenario);
      expect(await file.exists(), isFalse, reason: scenario);
      controller.dispose();
      await dir.delete(recursive: true);
    }
  });

  test(
      'completed installation cleans saved record, and deletion failure retains it',
      () async {
    final bytes = utf8.encode('apk data');
    final saved = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: '',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: bytes.length,
        sha256: sha256.convert(bytes).toString());
    for (final failing in [false, true]) {
      SharedPreferences.setMockInitialValues({
        'auto_update_checks': false,
        'downloaded_update_record': saved.toRecord()
      });
      final prefs = await PreferencesStore.create();
      final dir = await Directory.systemTemp.createTemp();
      final updateDir = await Directory('${dir.path}/updates').create();
      final file =
          await File('${updateDir.path}/update.apk').writeAsBytes(bytes);
      final controller = UpdateController(prefs,
          android: false,
          version: () async => '0.5.0',
          service: failing
              ? FailingCleanupService()
              : UpdateService(directory: () async => dir));
      await controller.initialized;
      expect(prefs.downloadedUpdateRecord != null, failing);
      expect(await file.exists(), failing);
      expect(controller.apk, isNull);
      controller.dispose();
      await dir.delete(recursive: true);
    }
  });

  testWidgets('restored update offers Install update without network',
      (tester) async {
    final bytes = utf8.encode('apk data');
    final saved = UpdateRelease(
        version: Version.parse('0.5.0'),
        notes: 'Notes',
        url: Uri.parse(
            'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk'),
        size: bytes.length,
        sha256: sha256.convert(bytes).toString());
    SharedPreferences.setMockInitialValues({
      'auto_update_checks': false,
      'downloaded_update_record': saved.toRecord()
    });
    final prefs = await PreferencesStore.create();
    late Directory dir;
    late UpdateController controller;
    await tester.runAsync(() async {
      dir = await Directory.systemTemp.createTemp();
      final updateDir = await Directory('${dir.path}/updates').create();
      await File('${updateDir.path}/update.apk').writeAsBytes(bytes);
      controller = UpdateController(prefs,
          android: false,
          version: () async => '0.4.0',
          service: UpdateService(directory: () async => dir));
      await controller.initialized;
    });
    addTearDown(controller.dispose);
    addTearDown(() => dir.delete(recursive: true));
    await tester.pumpWidget(ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: UpdateScreen())));
    expect(find.text('Install update'), findsOneWidget);
    expect(find.text('Download update'), findsNothing);
  });
}
