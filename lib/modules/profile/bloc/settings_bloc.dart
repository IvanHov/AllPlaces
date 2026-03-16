import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../common/theme/theme_manager.dart';
import '../../../common/localization/localization_manager.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ThemeManager _themeManager = ThemeManager();

  // In-memory storage for demo purposes
  // In a real app, this would use SharedPreferences or a database

  AppLanguage _language = AppLanguage.english;
  bool _notificationsEnabled = true;

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeTheme>(_onChangeTheme);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleNotifications>(_onToggleNotifications);
    on<ResetSettings>(_onResetSettings);
  }
  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final appVersion = AppVersion(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        codeName: 'Birthday Cake',
      );

      // Initialize language from current app locale if set
      final currentLocale = LocalizationManager().locale;

      if (currentLocale != null) {
        _language = AppLanguage.values.firstWhere(
          (lang) => lang.code == currentLocale.languageCode,
          orElse: () => AppLanguage.english,
        );
      } else {
        final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        _language = AppLanguage.values.firstWhere(
          (lang) => lang.code == deviceLocale.languageCode,
          orElse: () => AppLanguage.english,
        );
        LocalizationManager().setLocale(_language.toLocale());
      }

      emit(
        SettingsLoaded(
          themeMode: _themeManager.themeMode,
          language: _language,
          notificationsEnabled: _notificationsEnabled,
          appVersion: appVersion,
        ),
      );
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        // Update the theme manager with the new theme
        _themeManager.setThemeMode(event.themeMode);

        emit(currentState.copyWith(themeMode: event.themeMode));
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        _language = event.language;
        // propagate to app

        LocalizationManager().setLocale(event.language.toLocale());

        emit(currentState.copyWith(language: event.language));
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    }
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        _notificationsEnabled = event.enabled;
        emit(currentState.copyWith(notificationsEnabled: event.enabled));
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    }
  }

  Future<void> _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      _themeManager.setThemeMode(ThemeMode.system);
      _language = AppLanguage.english;
      _notificationsEnabled = true;
      // Reload default settings
      add(LoadSettings());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
