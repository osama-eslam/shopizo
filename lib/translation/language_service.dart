import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends GetxController {
  static const String _langKey = 'selected_language';

  void changeLanguage(String langCode) async {
    var locale = Locale(langCode);
    Get.updateLocale(locale);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_langKey, langCode);
  }

  Future<String> getSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey) ?? 'en';
  }
}
