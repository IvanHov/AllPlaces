import 'package:flutter/material.dart';

class LocalizationManager extends ChangeNotifier {
  static final LocalizationManager _instance = LocalizationManager._internal();
  factory LocalizationManager() => _instance;
  LocalizationManager._internal();

  Locale? _locale; // null means follow system

  Locale? get locale => _locale;

  void setLocale(Locale? locale) {
    if (_locale == locale || (locale != null && _locale == locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
