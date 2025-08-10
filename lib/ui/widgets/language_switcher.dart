import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/translation/language_service.dart';

class LanguageSwitcher extends StatelessWidget {
  final LanguageService langService = Get.put(LanguageService());

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      onPressed: () {
        String currentLang = Get.locale?.languageCode ?? 'en';
        String newLang = currentLang == 'en' ? 'ar' : 'en';
        LanguageService().changeLanguage(newLang);
      },
    );
  }
}
