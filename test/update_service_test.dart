import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:filebrowser_mobile/src/update/update_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> releaseJson(List<int> bytes) => {
      'tag_name': 'v0.5.0',
      'draft': false,
      'prerelease': false,
      'body': 'Changes',
      'assets': [
        {
          'name': 'filebrowser-mobile-v0.5.0.apk',
          'state': 'uploaded',
          'size': bytes.length,
          'digest': 'sha256:${sha256.convert(bytes)}',
          'browser_download_url':
              'https://github.com/Adiker/filebrowser-quantum-mobile/releases/download/v0.5.0/filebrowser-mobile-v0.5.0.apk',
        }
      ],
    };

class StreamingClient extends http.BaseClient {
  StreamingClient(this.stream);
  final Stream<List<int>> stream;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(stream, 200);
}

void main() {
  final bytes = utf8.encode('test apk');
  test('compares numeric versions and requires stable metadata', () {
    expect(UpdateRelease.parse(releaseJson(bytes), '0.4.9')!.version.toString(),
        '0.5.0');
    expect(UpdateRelease.parse(releaseJson(bytes), '0.5.0'), isNull);
    expect(UpdateRelease.parse(releaseJson(bytes), '0.10.0'), isNull);
    final json = releaseJson(bytes)..['prerelease'] = true;
    expect(() => UpdateRelease.parse(json, '0.1.0'),
        throwsA(isA<UpdateException>()));
  });
  test('rejects invalid digest, duplicate assets and wrong URL', () {
    for (final modify in <void Function(Map<String, dynamic>)>[
      (j) => ((j['assets'] as List).first as Map<String, dynamic>)['digest'] =
          'invalid',
      (j) => (j['assets'] as List).add((j['assets'] as List).first),
      (j) => ((j['assets'] as List).first
              as Map<String, dynamic>)['browser_download_url'] =
          'https://evil.example/file.apk',
    ]) {
      final json = releaseJson(bytes);
      modify(json);
      expect(() => UpdateRelease.parse(json, '0.1.0'),
          throwsA(isA<UpdateException>()));
    }
  });
  test('downloads via trusted redirect and verifies integrity', () async {
    final dir = await Directory.systemTemp.createTemp();
    addTearDown(() => dir.delete(recursive: true));
    final client = MockClient((request) async {
      if (request.url.host == 'github.com') {
        return http.Response('', 302, headers: {
          'location': 'https://release-assets.githubusercontent.com/file'
        });
      }
      return http.Response.bytes(bytes, 200);
    });
    final service =
        UpdateService(downloadClient: () => client, directory: () async => dir);
    addTearDown(service.dispose);
    var progress = 0.0;
    final file = await service.download(
        UpdateRelease.parse(releaseJson(bytes), '0.1.0')!, (v) => progress = v);
    expect(await file.readAsBytes(), bytes);
    expect(progress, 1);
  });
  test('deletes bad downloads and blocks unsafe redirects', () async {
    for (final unsafe in [false, true]) {
      final dir = await Directory.systemTemp.createTemp();
      final service = UpdateService(
          directory: () async => dir,
          downloadClient: () => MockClient((request) async => unsafe
              ? http.Response('', 302,
                  headers: {'location': 'https://evil.example/apk'})
              : http.Response.bytes(utf8.encode('bad file'), 200)));
      await expectLater(
          service.download(
              UpdateRelease.parse(releaseJson(bytes), '0.1.0')!, (_) {}),
          throwsA(isA<UpdateException>()));
      expect(await File('${dir.path}/updates/update.apk').exists(), isFalse);
      service.dispose();
      await dir.delete(recursive: true);
    }
  });
  test('cancelling removes the incomplete download', () async {
    final dir = await Directory.systemTemp.createTemp();
    final chunks = StreamController<List<int>>();
    final service = UpdateService(
        directory: () async => dir,
        downloadClient: () => StreamingClient(chunks.stream));
    final started = Completer<void>();
    final future = service
        .download(UpdateRelease.parse(releaseJson(bytes), '0.1.0')!, (_) {
      if (!started.isCompleted) started.complete();
    });
    chunks.add(bytes.sublist(0, 2));
    await started.future;
    service.cancel();
    chunks.add(bytes.sublist(2));
    await chunks.close();
    await expectLater(future, throwsA(isA<UpdateException>()));
    expect(await File('${dir.path}/updates/update.apk').exists(), isFalse);
    service.dispose();
    await dir.delete(recursive: true);
  });
}
