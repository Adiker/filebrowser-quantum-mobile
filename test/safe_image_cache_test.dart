import 'package:filebrowser_mobile/src/api/safe_image_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('image requests do not follow redirects with bearer credentials',
      () async {
    var calls = 0;
    final service = NoRedirectFileService(client: MockClient((request) async {
      calls++;
      expect(request.followRedirects, isFalse);
      expect(request.headers['Authorization'], 'Bearer secret');
      return http.Response('', 302,
          headers: {'location': 'http://other.example/'});
    }));
    final response = await service.get('https://server.example/image',
        headers: {'Authorization': 'Bearer secret'});
    expect(response.statusCode, 302);
    expect(calls, 1);
  });
}
