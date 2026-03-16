import 'package:flutter/material.dart';

class LocalizationHelper {
  static String getCurrentLanguageCode(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    // Map the locale to our supported language codes
    switch (locale.languageCode) {
      case 'uz':
        return 'name_uz';
      case 'ru':
        return 'name_ru';
      case 'en':
      default:
        return 'name_en';
    }
  }

  static String getLanguageCodeFromLocale(String languageCode) {
    // Convert language code to our naming convention
    switch (languageCode) {
      case 'uz':
        return 'name_uz';
      case 'ru':
        return 'name_ru';
      case 'en':
      default:
        return 'name_en';
    }
  }
}
