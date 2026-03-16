import 'package:equatable/equatable.dart';

class _Keys {
  static const String uz = 'description_uz';
  static const String ru = 'description_ru';
  static const String en = 'description_en';
}

class LocationDescription extends Equatable {
  final String? uz;
  final String? ru;
  final String? en;

  const LocationDescription({this.uz, this.ru, this.en});

  factory LocationDescription.fromJson(Map<String, dynamic> json) {
    return LocationDescription(
      uz: json[_Keys.uz] as String?,
      ru: json[_Keys.ru] as String?,
      en: json[_Keys.en] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {_Keys.uz: uz, _Keys.ru: ru, _Keys.en: en};
  }

  String? getByLanguage(String language) {
    switch (language) {
      case 'uz':
        return uz;
      case 'ru':
        return ru;
      default:
        return en;
    }
  }

  bool get hasDescription => uz != null || ru != null || en != null;

  @override
  List<Object?> get props => [uz, ru, en];
}
