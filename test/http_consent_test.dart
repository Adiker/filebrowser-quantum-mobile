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

class RecordingAuth extends AuthController {
  RecordingAuth(PreferencesStore prefs) : super(prefs: prefs);
  bool alreadyConfirmed = false;
  int submissions = 0;
  bool confirmed = false;

  @override
  AuthStage get stage => AuthStage.needsSetup;

  @override
  Future<bool> hasHttpConsent(String baseUrl) async => alreadyConfirmed;

  @override
  Future<void> beginSetup(
      {required String baseUrl,
      required String username,
      required String password,
      bool confirmHttp = false}) async {
    submissions++;
    confirmed = confirmHttp;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('consent is bound to one exact URL and can be cleared', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final store = SecureStore();
    await store.setHttpConsent('http://nas.local:8080');
    expect(await store.hasHttpConsent('http://nas.local:8080'), isTrue);
    expect(await store.hasHttpConsent('http://nas.local:8081'), isFalse);
    expect(await store.hasHttpConsent('http://other.local:8080'), isFalse);
    await store.clear();
    expect(await store.hasHttpConsent('http://nas.local:8080'), isFalse);
  });

  test('controller refuses HTTP before storing credentials without consent',
      () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final store = SecureStore();
    final auth =
        AuthController(prefs: await PreferencesStore.create(), store: store);
    await auth.beginSetup(
        baseUrl: 'http://nas.local', username: 'u', password: 'p');
    expect(auth.stage, AuthStage.needsSetup);
    expect(auth.error, contains('Confirm'));
    expect(await store.hasCredentials, isFalse);
  });

  testWidgets('HTTP warning can be cancelled or confirmed', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final auth = RecordingAuth(await PreferencesStore.create());
    await tester.pumpWidget(ChangeNotifierProvider<AuthController>.value(
        value: auth, child: l10nWrap(const LoginScreen())));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'http://nas.local:8080');
    await tester.enterText(fields.at(1), 'user');
    await tester.enterText(fields.at(2), 'password');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Unencrypted connection'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(auth.submissions, 0);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Connect over HTTP'));
    await tester.pumpAndSettle();
    expect(auth.submissions, 1);
    expect(auth.confirmed, isTrue);
  });

  testWidgets('HTTPS and already confirmed HTTP do not prompt', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final auth = RecordingAuth(await PreferencesStore.create());
    await tester.pumpWidget(ChangeNotifierProvider<AuthController>.value(
        value: auth, child: l10nWrap(const LoginScreen())));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'nas.local');
    await tester.enterText(fields.at(1), 'user');
    await tester.enterText(fields.at(2), 'password');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(auth.submissions, 1);
    auth.alreadyConfirmed = true;
    await tester.enterText(fields.at(0), 'http://nas.local');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Unencrypted connection'), findsNothing);
    expect(auth.submissions, 2);
  });
}
