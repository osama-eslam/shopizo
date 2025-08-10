import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/core/theme_preferences.dart';
import 'package:image_picker_demo/translation/language_service.dart';
import 'package:image_picker_demo/translation/translation_service.dart';
import 'package:image_picker_demo/ui/pages/home/home page.dart';
import 'package:image_picker_demo/ui/pages/theme/app_theme.dart';
import 'package:image_picker_demo/ui/pages/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialThemeMode = await ThemePreference.getInitialTheme();
  final langService = LanguageService();
  String savedLang = await langService.getSavedLanguage();

  runApp(MyApp(initialThemeMode: initialThemeMode, savedLang: savedLang));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final String savedLang;

  const MyApp({
    super.key,
    required this.initialThemeMode,
    required this.savedLang,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void _setThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    await ThemePreference.saveThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return MyAppTheme(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Locale(widget.savedLang),
        fallbackLocale: const Locale('en'),
        themeMode: _themeMode,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        home: const Homepage(),
      ),
    );
  }
}
