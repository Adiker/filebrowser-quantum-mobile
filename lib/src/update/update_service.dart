import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pub_semver/pub_semver.dart';

const _repository = 'Adiker/filebrowser-quantum-mobile';
const _api = 'https://api.github.com/repos/$_repository/releases/latest';
const _maxApkSize = 300 * 1024 * 1024;

class UpdateException implements Exception {
  UpdateException(this.message);
  final String message;
  @override
  String toString() => message;
}

class UpdateRelease {
  const UpdateRelease(
      {required this.version,
      required this.notes,
      required this.url,
      required this.size,
      required this.sha256});
  final Version version;
  final String notes;
  final Uri url;
  final int size;
  final String sha256;

  static UpdateRelease? parse(Map<String, dynamic> json, String current) {
    if (json['draft'] != false || json['prerelease'] != false) {
      throw UpdateException('Not a stable release');
    }
    final tag = json['tag_name'];
    if (tag is! String ||
        !RegExp(r'^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$').hasMatch(tag)) {
      throw UpdateException('Invalid release version');
    }
    final version = Version.parse(tag.substring(1));
    final installed = Version.parse(current);
    if (version <= installed) return null;
    final assets = json['assets'];
    if (assets is! List) throw UpdateException('Missing release assets');
    final matching = assets
        .whereType<Map<String, dynamic>>()
        .where((a) =>
            a['name'] == 'filebrowser-mobile-$tag.apk' &&
            a['state'] == 'uploaded')
        .toList();
    if (matching.length != 1) throw UpdateException('Invalid APK asset');
    final asset = matching.single;
    final size = asset['size'];
    final digest = asset['digest'];
    final url = Uri.tryParse(asset['browser_download_url'] is String
        ? asset['browser_download_url'] as String
        : '');
    if (size is! int ||
        size <= 0 ||
        size > _maxApkSize ||
        digest is! String ||
        !RegExp(r'^sha256:[a-fA-F0-9]{64}$').hasMatch(digest) ||
        url == null ||
        url.scheme != 'https' ||
        url.host != 'github.com' ||
        url.path !=
            '/$_repository/releases/download/$tag/filebrowser-mobile-$tag.apk' ||
        url.hasQuery ||
        url.hasFragment ||
        url.userInfo.isNotEmpty ||
        url.hasPort) {
      throw UpdateException('Invalid APK metadata');
    }
    return UpdateRelease(
        version: version,
        notes: json['body'] is String ? json['body'] as String : '',
        url: url,
        size: size,
        sha256: digest.substring(7).toLowerCase());
  }
}

class UpdateService {
  UpdateService(
      {http.Client? client,
      http.Client Function()? downloadClient,
      Future<Directory> Function()? directory})
      : _client = client ?? http.Client(),
        _downloadClientFactory = downloadClient ?? (() => http.Client()),
        _directory = directory ?? getApplicationSupportDirectory;
  final http.Client _client;
  final http.Client Function() _downloadClientFactory;
  final Future<Directory> Function() _directory;
  bool _cancelled = false;
  http.Client? _downloadClient;

  Future<UpdateRelease?> check(String currentVersion) async {
    final response = await _client.get(Uri.parse(_api), headers: {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    }).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw UpdateException('GitHub HTTP ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw UpdateException('Invalid GitHub response');
    }
    return UpdateRelease.parse(data, currentVersion);
  }

  Future<void> clearDownloads() async {
    final dir = Directory(path.join((await _directory()).path, 'updates'));
    if (!await dir.exists()) return;
    await for (final entity in dir.list()) {
      if (entity is File) await entity.delete();
    }
  }

  void cancel() {
    _cancelled = true;
    _downloadClient?.close();
  }

  Future<File> download(
      UpdateRelease release, void Function(double) onProgress) async {
    _cancelled = false;
    final dir = Directory(path.join((await _directory()).path, 'updates'));
    await dir.create(recursive: true);
    await clearDownloads();
    final file = File(path.join(dir.path, 'update.apk'));
    final client = _downloadClientFactory();
    _downloadClient = client;
    IOSink? sink;
    try {
      var url = release.url;
      http.StreamedResponse? response;
      for (var redirects = 0; redirects <= 5; redirects++) {
        if (_cancelled) throw UpdateException('Download cancelled');
        if (url.scheme != 'https' ||
            url.userInfo.isNotEmpty ||
            url.hasPort ||
            !{
              'github.com',
              'release-assets.githubusercontent.com',
              'objects.githubusercontent.com'
            }.contains(url.host)) {
          throw UpdateException('Unsafe download redirect');
        }
        final request = http.Request('GET', url)..followRedirects = false;
        response =
            await client.send(request).timeout(const Duration(seconds: 30));
        if (response.statusCode >= 300 && response.statusCode < 400) {
          final location = response.headers['location'];
          await response.stream
              .drain<void>()
              .timeout(const Duration(seconds: 30));
          if (location == null || redirects == 5) {
            throw UpdateException('Invalid download redirect');
          }
          url = url.resolve(location);
          continue;
        }
        break;
      }
      if (response == null || response.statusCode != 200) {
        throw UpdateException('Download failed: HTTP ${response?.statusCode}');
      }
      sink = file.openWrite();
      var count = 0;
      await for (final chunk
          in response.stream.timeout(const Duration(seconds: 30))) {
        if (_cancelled) throw UpdateException('Download cancelled');
        count += chunk.length;
        if (count > release.size) throw UpdateException('APK size mismatch');
        sink.add(chunk);
        onProgress(count / release.size);
      }
      await sink.flush();
      await sink.close();
      sink = null;
      if (count != release.size ||
          (await sha256.bind(file.openRead()).first).toString() !=
              release.sha256) {
        throw UpdateException('APK integrity check failed');
      }
      return file;
    } catch (_) {
      await sink?.close();
      if (await file.exists()) await file.delete();
      rethrow;
    } finally {
      client.close();
      if (identical(_downloadClient, client)) _downloadClient = null;
    }
  }

  void dispose() {
    cancel();
    _client.close();
  }
}
