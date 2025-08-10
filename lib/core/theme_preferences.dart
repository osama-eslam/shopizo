import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const _themeKey = 'themeMode';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final modeString =
        mode == ThemeMode.light
            ? 'light'
            : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await prefs.setString(_themeKey, modeString);
  }

  static Future<ThemeMode> getInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey) ?? 'system';

    switch (savedTheme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
