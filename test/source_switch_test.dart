import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:filebrowser_mobile/src/api/filebrowser_client.dart';
import 'package:filebrowser_mobile/src/api/models.dart';
import 'package:filebrowser_mobile/src/auth/auth_controller.dart';
import 'package:filebrowser_mobile/src/data/preferences_store.dart';
import 'package:filebrowser_mobile/src/transfers/transfer_service.dart';
import 'package:filebrowser_mobile/src/ui/browser_screen.dart';

import 'support/fakes.dart';
import 'support/l10n.dart';
import 'support/mock_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ReceiveSharingIntent.setMockValues(
        initialMedia: const [], mediaStream: const Stream.empty());
  });

  Future<
          ({
            PreferencesStore prefs,
            FileBrowserClient client,
            MockAdapter adapter
          })>
      pumpBrowser(WidgetTester tester,
          {Object? sources, int status = 200}) async {
    final prefs = await PreferencesStore.create();
    final adapter = MockAdapter((request) {
      if (request.uri.path.endsWith('/settings/sources')) {
        return MockAdapter.json(sources ?? {'alpha': {}, 'beta': {}},
            status: status);
      }
      final path = request.uri.queryParameters['path'] ?? '/';
      final source = request.uri.queryParameters['source'];
      return MockAdapter.json({
        'path': path,
        'name': path,
        'isDir': true,
        'size': 0,
        'items': path == '/' && source == 'alpha'
            ? [
                {'path': '/docs', 'name': 'docs', 'size': 0, 'isDir': true}
              ]
            : [
                {
                  'path': '$path/item.txt',
                  'name': '$source item',
                  'size': 1,
                  'isDir': false
                }
              ],
      });
    });
    final client =
        FileBrowserClient(baseUrl: 'https://example.com', adapter: adapter)
          ..adoptToken('token')
          ..setSource('alpha');
    final auth = FakeAuth(client,
        FbUser(username: 'user', canCreate: true, canModify: true), prefs);
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<PreferencesStore>.value(value: prefs),
        Provider<TransferService>(create: (_) => TransferService()),
        ChangeNotifierProvider<AuthController>.value(value: auth),
      ],
      child: l10nWrap(const BrowserScreen()),
    ));
    await tester.pumpAndSettle();
    return (prefs: prefs, client: client, adapter: adapter);
  }

  Future<void> openSelector(WidgetTester tester) async {
    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change source'));
    await tester.pumpAndSettle();
  }

  testWidgets('switch resets path, persists source, and preserves session',
      (tester) async {
    final state = await pumpBrowser(tester);
    await tester.tap(find.text('docs'));
    await tester.pumpAndSettle();
    await openSelector(tester);
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.tap(find.text('beta'));
    await tester.pumpAndSettle();
    expect(find.text('beta item'), findsOneWidget);
    expect(state.client.source, 'beta');
    expect(state.client.token, 'token');
    expect((await PreferencesStore.create()).sourceName, 'beta');
    final listing = state.adapter.requests.last;
    expect(listing.uri.queryParameters['source'], 'beta');
    expect(listing.uri.queryParameters['path'], '/');
  });

  testWidgets('cancel and current source preserve directory and selection',
      (tester) async {
    final state = await pumpBrowser(tester);
    await tester.tap(find.text('docs'));
    await tester.pumpAndSettle();
    await openSelector(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await openSelector(tester);
    await tester.tap(find.text('alpha'));
    await tester.pumpAndSettle();
    expect(find.text('alpha item'), findsOneWidget);
    expect(state.client.source, 'alpha');
    expect(state.prefs.sourceName, isNull);
    expect(
        state.adapter.requests
            .where((r) => r.uri.path.endsWith('/resources'))
            .length,
        2);
  });

  testWidgets('single source is selectable without a switch', (tester) async {
    final state = await pumpBrowser(tester, sources: {'alpha': {}});
    await openSelector(tester);
    expect(find.text('alpha'), findsOneWidget);
    await tester.tap(find.text('alpha'));
    await tester.pumpAndSettle();
    expect(state.client.source, 'alpha');
  });

  testWidgets('empty list and server error are shown', (tester) async {
    await pumpBrowser(tester, sources: <String, Object>{});
    await openSelector(tester);
    expect(find.text('No sources are available.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await pumpBrowser(tester, status: 500);
    await openSelector(tester);
    expect(
        find.text('Could not load sources. Please try again.'), findsOneWidget);
  });
}
