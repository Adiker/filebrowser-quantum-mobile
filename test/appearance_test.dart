import 'package:filebrowser_mobile/l10n/app_localizations.dart';
import 'package:filebrowser_mobile/src/appearance.dart';
import 'package:filebrowser_mobile/src/data/preferences_store.dart';
import 'package:filebrowser_mobile/src/ui/appearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('preferences persist and unknown values use defaults', () async {
    SharedPreferences.setMockInitialValues({
      'pref_appearance_mode': 'invalid',
      'pref_appearance_color': 12,
      'pref_amoled': 'invalid',
    });
    final prefs = await PreferencesStore.create();
    expect(prefs.appearanceMode, AppearanceMode.system);
    expect(prefs.appearanceColor, AppearanceColor.system);
    expect(prefs.amoled, false);
    final appearance = AppearanceController(prefs);
    appearance.setMode(AppearanceMode.dark);
    appearance.setColor(AppearanceColor.teal);
    appearance.setAmoled(true);
    final reopened = AppearanceController(await PreferencesStore.create());
    expect(reopened.mode, AppearanceMode.dark);
    expect(reopened.color, AppearanceColor.teal);
    expect(reopened.amoled, true);
  });

  test('dynamic colors, fallback and AMOLED are applied to correct brightness',
      () async {
    SharedPreferences.setMockInitialValues({});
    final appearance = AppearanceController(await PreferencesStore.create());
    final dynamic = ColorScheme.fromSeed(seedColor: Colors.pink);
    expect(
        appearance.buildTheme(Brightness.light, dynamic).colorScheme, dynamic);
    expect(appearance.buildTheme(Brightness.light, null).colorScheme,
        ColorScheme.fromSeed(seedColor: Colors.indigo));
    appearance.setAmoled(true);
    expect(appearance.buildTheme(Brightness.dark, null).scaffoldBackgroundColor,
        Colors.black);
    expect(
        appearance.buildTheme(Brightness.light, null).scaffoldBackgroundColor,
        isNot(Colors.black));
    appearance.setColor(AppearanceColor.teal);
    expect(appearance.buildTheme(Brightness.light, dynamic).colorScheme,
        ColorScheme.fromSeed(seedColor: Colors.teal));
  });

  testWidgets('settings update immediately, follow system and preserve route',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppearanceController(await PreferencesStore.create());
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<AppearanceController>(
          builder: (context, appearance, _) => MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                themeMode: appearance.themeMode,
                theme: appearance.buildTheme(Brightness.light, null),
                darkTheme: appearance.buildTheme(Brightness.dark, null),
                home: const AppearanceScreen(),
              )),
    ));
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    expect(controller.amoled, true);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpAndSettle();
    expect(
        Theme.of(tester.element(find.byType(AppearanceScreen)))
            .scaffoldBackgroundColor,
        Colors.black);
    await tester.tap(find.byType(DropdownButtonFormField<AppearanceMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light').last);
    await tester.pumpAndSettle();
    expect(controller.mode, AppearanceMode.light);
    expect(find.byType(AppearanceScreen), findsOneWidget);
    expect(Theme.of(tester.element(find.byType(AppearanceScreen))).brightness,
        Brightness.light);
    await tester.tap(find.byType(DropdownButtonFormField<AppearanceColor>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teal').last);
    await tester.pumpAndSettle();
    expect(controller.color, AppearanceColor.teal);
    expect((await PreferencesStore.create()).appearanceColor,
        AppearanceColor.teal);
  });
}
