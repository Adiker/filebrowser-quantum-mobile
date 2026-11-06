import 'dart:io';

import 'package:dio/dio.dart';
import 'package:filebrowser_mobile/src/api/filebrowser_client.dart';
import 'package:filebrowser_mobile/src/auth/auth_controller.dart';
import 'package:filebrowser_mobile/src/auth/secure_store.dart';
import 'package:filebrowser_mobile/src/data/preferences_store.dart';
import 'package:filebrowser_mobile/src/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/l10n.dart';
import 'support/mock_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(AuthController, SecureStore)> showLogin(
      WidgetTester tester, MockAdapter adapter, String address) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final store = SecureStore();
    final auth = AuthController(
      prefs: await PreferencesStore.create(),
      store: store,
      clientFactory: (url) => FileBrowserClient(baseUrl: url, adapter: adapter),
    );
    await auth.bootstrap();
    await tester.pumpWidget(ChangeNotifierProvider<AuthController>.value(
        value: auth, child: l10nWrap(const LoginScreen())));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), address);
    await tester.enterText(fields.at(1), 'user');
    await tester.enterText(fields.at(2), 'password');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    return (auth, store);
  }

  for (final failure in ['connection', 'tls']) {
    testWidgets('$failure failure offers HTTP only after consent',
        (tester) async {
      final adapter = MockAdapter((request) {
        if (request.uri.scheme == 'https') {
          throw DioException(
            requestOptions: request,
            type: failure == 'connection'
                ? DioExceptionType.connectionError
                : DioExceptionType.unknown,
            error: failure == 'tls' ? const HandshakeException('TLS') : null,
          );
        }
        return MockAdapter.text('invalid', status: 401);
      });
      final (auth, store) =
          await showLogin(tester, adapter, 'nas.local:8080/fb');
      expect(find.text('HTTPS connection failed'), findsOneWidget);
      expect(find.textContaining('http://nas.local:8080/fb'), findsOneWidget);
      expect(adapter.requests.map((r) => r.uri.scheme), ['https']);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(adapter.requests.length, 1);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Connect over HTTP'));
      await tester.pumpAndSettle();
      expect(adapter.requests.map((r) => r.uri.scheme),
          ['https', 'https', 'http']);
      expect(adapter.requests.last.uri.toString(),
          startsWith('http://nas.local:8080/fb/api/auth/login'));
      expect(await store.hasHttpConsent('http://nas.local:8080/fb'), isTrue);
      expect(auth.loginConnectionFailed, isFalse);
    });
  }

  testWidgets('fallback preserves an explicitly supplied HTTPS default port',
      (tester) async {
    final adapter = MockAdapter((request) => throw DioException(
        requestOptions: request, type: DioExceptionType.connectionError));
    await showLogin(tester, adapter, 'nas.local:443/fb');
    expect(find.textContaining('http://nas.local:443/fb'), findsOneWidget);
    await tester.tap(find.text('Connect over HTTP'));
    await tester.pumpAndSettle();
    expect(adapter.requests.last.uri.port, 443);
  });

  testWidgets('successful HTTPS does not offer HTTP', (tester) async {
    final adapter = MockAdapter((request) =>
        request.uri.path.endsWith('/auth/login')
            ? MockAdapter.text('token')
            : MockAdapter.json({}));
    final (auth, _) = await showLogin(tester, adapter, 'nas.local');
    expect(find.text('HTTPS connection failed'), findsNothing);
    expect(auth.stage, AuthStage.authenticated);
    expect(adapter.requests.every((r) => r.uri.scheme == 'https'), isTrue);
  });

  testWidgets('authentication error does not offer HTTP', (tester) async {
    final adapter =
        MockAdapter((_) => MockAdapter.text('invalid', status: 401));
    await showLogin(tester, adapter, 'nas.local');
    expect(find.text('HTTPS connection failed'), findsNothing);
    expect(adapter.requests.single.uri.scheme, 'https');
  });

  testWidgets('explicit HTTPS does not offer HTTP on connection error',
      (tester) async {
    final adapter = MockAdapter((request) => throw DioException(
        requestOptions: request, type: DioExceptionType.connectionError));
    await showLogin(tester, adapter, 'https://nas.local');
    expect(find.text('HTTPS connection failed'), findsNothing);
    expect(adapter.requests.single.uri.scheme, 'https');
  });

  testWidgets('previous HTTP consent survives an HTTPS attempt',
      (tester) async {
    final adapter = MockAdapter((request) => throw DioException(
        requestOptions: request, type: DioExceptionType.connectionError));
    final (_, store) = await showLogin(tester, adapter, 'nas.local');
    await tester.tap(find.text('Connect over HTTP'));
    await tester.pumpAndSettle();
    expect(await store.hasHttpConsent('http://nas.local'), isTrue);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(await store.hasHttpConsent('http://nas.local'), isTrue);
  });
}
