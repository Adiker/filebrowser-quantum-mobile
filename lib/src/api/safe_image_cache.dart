import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// Images carry bearer tokens. Never forward them to a redirect target.
class NoRedirectFileService extends FileService {
  NoRedirectFileService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final request = http.Request('GET', Uri.parse(url))
      ..followRedirects = false;
    if (headers != null) request.headers.addAll(headers);
    return HttpGetResponse(await _client.send(request), request.url);
  }
}

final safeImageCache = CacheManager(Config(
  'filebrowserSafeImages',
  fileService: NoRedirectFileService(),
));
