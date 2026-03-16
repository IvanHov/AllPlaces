import 'package:equatable/equatable.dart';

class _Keys {
  static const String uz = 'name_uz';
  static const String ru = 'name_ru';
  static const String en = 'name_en';
}

class LocalizedName extends Equatable {
  final String uz;
  final String ru;
  final String en;

  const LocalizedName({required this.uz, required this.ru, required this.en});

  factory LocalizedName.fromJson(Map<String, dynamic> json) {
    return LocalizedName(
      uz: json[_Keys.uz] as String? ?? '',
      ru: json[_Keys.ru] as String? ?? '',
      en: json[_Keys.en] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {_Keys.uz: uz, _Keys.ru: ru, _Keys.en: en};
  }

  String getByLanguage(String language) {
    switch (language) {
      case _Keys.uz:
        return uz;
      case _Keys.ru:
        return ru;
      default:
        return en;
    }
  }

  @override
  List<Object?> get props => [uz, ru, en];
}
