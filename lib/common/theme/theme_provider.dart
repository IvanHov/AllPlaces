import 'package:flutter/material.dart';
import 'theme_manager.dart';

/// A provider that connects ThemeManager with BLoC architecture
class ThemeProvider extends ChangeNotifier {
  ThemeProvider._internal() {
    _themeManager.addListener(_onThemeManagerChanged);
  }

  final ThemeManager _themeManager = ThemeManager();

  ThemeMode get themeMode => _themeManager.themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeManager.setThemeMode(mode);
  }

  void _onThemeManagerChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeManagerChanged);
    super.dispose();
  }
}
