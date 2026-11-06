import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import 'auth/auth_controller.dart';
import 'appearance.dart';
import 'data/preferences_store.dart';
import 'transfers/transfer_service.dart';
import 'ui/browser_screen.dart';
import 'ui/login_screen.dart';

class FileBrowserApp extends StatelessWidget {
  const FileBrowserApp({super.key, required this.prefs});

  /// Pre-resolved preferences store (see [main]); injected via Provider.value
  /// since its async creation is awaited during bootstrap, before runApp.
  final PreferencesStore prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferencesStore>.value(value: prefs),
        ChangeNotifierProvider(create: (_) => AppearanceController(prefs)),
        Provider<TransferService>(
          create: (_) => TransferService()..init(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (ctx) => AuthController(
            prefs: prefs,
            onForget: ctx.read<TransferService>().purgeAll,
          )..bootstrap(),
        ),
      ],
      child: Consumer<AppearanceController>(
        builder: (context, appearance, _) => DynamicColorBuilder(
          builder: (light, dark) => MaterialApp(
            onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            themeMode: appearance.themeMode,
            theme: appearance.buildTheme(Brightness.light, light),
            darkTheme: appearance.buildTheme(Brightness.dark, dark),
            home: const _AuthGate(),
          ),
        ),
      ),
    );
  }
}

/// Routes between setup, lock, and the browser based on [AuthStage].
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    switch (auth.stage) {
      case AuthStage.needsSetup:
        return const LoginScreen();
      case AuthStage.locked:
        return const LockScreen();
      case AuthStage.needsSource:
        return const SourceSelectScreen();
      case AuthStage.authenticated:
        return const BrowserScreen();
      case AuthStage.busy:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
    }
  }
}
