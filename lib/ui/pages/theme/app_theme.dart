import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2196F3),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF0D47A1),
    ),
    cardColor: Colors.white,
  );

  static final darkTheme = ThemeData.dark().copyWith(
    cardColor: Colors.grey[900],
  );
}
