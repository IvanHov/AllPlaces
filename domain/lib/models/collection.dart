import 'package:domain/models/location_name.dart';
import 'package:equatable/equatable.dart';

class _Keys {
  static const String id = 'id';
  static const String nameRu = 'name_ru';
  static const String nameEn = 'name_en';
  static const String nameUz = 'name_uz';
  static const String locationsId = 'locations_id';
}

class Collection extends Equatable {
  final String id;
  final LocalizedName name;
  final List<String> locationIds;

  const Collection({
    required this.id,
    required this.name,
    required this.locationIds,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    // Parse the locations_id as a list of strings
    List<String> locationIds =
        (json[_Keys.locationsId] as List<dynamic>?)
            ?.map((id) => id as String)
            .toList() ??
        [];

    return Collection(
      id: json[_Keys.id] as String,
      name: LocalizedName(
        ru: json[_Keys.nameRu] as String? ?? '',
        en: json[_Keys.nameEn] as String? ?? '',
        uz: json[_Keys.nameUz] as String? ?? '',
      ),
      locationIds: locationIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _Keys.id: id,
      _Keys.nameRu: name.ru,
      _Keys.nameEn: name.en,
      _Keys.nameUz: name.uz,
      _Keys.locationsId: locationIds,
    };
  }

  @override
  List<Object?> get props => [id, name, locationIds];
}
