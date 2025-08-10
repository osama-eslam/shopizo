import 'package:flutter/material.dart';

class MyAppTheme extends InheritedWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) setThemeMode;

  const MyAppTheme({
    required this.themeMode,
    required this.setThemeMode,
    required Widget child,
    super.key,
  }) : super(child: child);

  static MyAppTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppTheme>();
  }

  @override
  bool updateShouldNotify(MyAppTheme oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
