import 'package:flutter/material.dart';

import 'data/preferences_store.dart';

class AppearanceController extends ChangeNotifier {
  AppearanceController(this._prefs)
      : mode = _prefs.appearanceMode,
        color = _prefs.appearanceColor,
        amoled = _prefs.amoled;

  final PreferencesStore _prefs;
  AppearanceMode mode;
  AppearanceColor color;
  bool amoled;

  ThemeMode get themeMode => switch (mode) {
        AppearanceMode.system => ThemeMode.system,
        AppearanceMode.light => ThemeMode.light,
        AppearanceMode.dark => ThemeMode.dark,
      };

  void setMode(AppearanceMode value) {
    mode = value;
    notifyListeners();
    _prefs.setAppearanceMode(value);
  }

  void setColor(AppearanceColor value) {
    color = value;
    notifyListeners();
    _prefs.setAppearanceColor(value);
  }

  void setAmoled(bool value) {
    amoled = value;
    notifyListeners();
    _prefs.setAmoled(value);
  }

  static Color seedFor(AppearanceColor color) => switch (color) {
        AppearanceColor.system || AppearanceColor.indigo => Colors.indigo,
        AppearanceColor.blue => Colors.blue,
        AppearanceColor.teal => Colors.teal,
        AppearanceColor.green => Colors.green,
        AppearanceColor.orange => Colors.orange,
        AppearanceColor.pink => Colors.pink,
      };

  ThemeData buildTheme(Brightness brightness, ColorScheme? dynamicScheme) {
    var scheme = color == AppearanceColor.system && dynamicScheme != null
        ? dynamicScheme
        : ColorScheme.fromSeed(
            seedColor: seedFor(color), brightness: brightness);
    if (brightness == Brightness.dark && amoled) {
      scheme = scheme.copyWith(
        surface: Colors.black,
        surfaceDim: Colors.black,
        surfaceContainerLowest: Colors.black,
        surfaceContainerLow: const Color(0xff080808),
        surfaceContainer: const Color(0xff101010),
        surfaceContainerHigh: const Color(0xff191919),
        surfaceContainerHighest: const Color(0xff222222),
      );
    }
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
    );
  }
}
