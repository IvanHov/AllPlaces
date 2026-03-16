part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final ThemeMode themeMode;
  final AppLanguage language;
  final bool notificationsEnabled;
  final AppVersion appVersion;

  const SettingsLoaded({
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.appVersion,
  });

  SettingsLoaded copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    bool? notificationsEnabled,
    AppVersion? appVersion,
  }) {
    return SettingsLoaded(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    language,
    notificationsEnabled,
    appVersion,
  ];
}

final class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Extension to add display properties to ThemeMode
extension ThemeModeExtension on ThemeMode {
  String get displayName {
    switch (this) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  String get description {
    switch (this) {
      case ThemeMode.light:
        return 'Light theme';
      case ThemeMode.dark:
        return 'Dark theme';
      case ThemeMode.system:
        return 'Follow system settings';
    }
  }
}

enum AppLanguage {
  english('en', 'English', 'English'),
  russian('ru', 'Русский', 'Russian'),
  uzbek('uz', 'Oʻzbekcha', 'Uzbek');

  const AppLanguage(this.code, this.displayName, this.nativeName);

  final String code;
  final String displayName;
  final String nativeName;
}

extension AppLanguageX on AppLanguage {
  Locale toLocale() => Locale(code);
}

class AppVersion extends Equatable {
  final String version;
  final String buildNumber;
  final String codeName;

  const AppVersion({
    required this.version,
    required this.buildNumber,
    required this.codeName,
  });

  @override
  List<Object?> get props => [version, buildNumber, codeName];
}
