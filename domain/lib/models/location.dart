import 'package:domain/models/location_name.dart';
import 'package:domain/models/location_description.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/models/coordinate_geometry.dart';

class _Keys {
  static const String id = 'id';
  static const String name = 'name';
  static const String type = 'type';
  static const String elevation = 'elevation';
  static const String geometryType = 'geometry_type';
  static const String coordinates = 'coordinates';
  static const String gallery = 'gallery';
}

enum LocationType { peak, cave, lake, river, waterfall, nationalPark, unknown }

extension LocationTypeExtension on LocationType {
  static LocationType fromString(String type) {
    switch (type) {
      case 'peak':
        return LocationType.peak;
      case 'cave':
        return LocationType.cave;
      case 'lake':
        return LocationType.lake;
      case 'waterfall':
        return LocationType.waterfall;
      case 'river':
        return LocationType.river;
      case 'national_park':
        return LocationType.nationalPark;
      default:
        return LocationType.unknown;
    }
  }

  String toJson() {
    return toString().split('.').last;
  }
}

class Location extends Equatable {
  final String id;
  final LocalizedName name;
  final LocationType type;
  final LocationDescription description;
  final double? elevation;
  final String? geometryType;
  final CoordinatesGeometry? coordinates;
  final List<String>? gallery;

  const Location({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.elevation,
    this.geometryType,
    this.coordinates,
    this.gallery,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    // Parse gallery field directly from JSON array
    List<String>? gallery;
    final galleryList = json[_Keys.gallery] as List<dynamic>?;
    if (galleryList != null && galleryList.isNotEmpty) {
      gallery = galleryList.map((item) => item as String).toList();
    }

    // Accept both parsed JSON (List/Map) and legacy String values.
    final rawCoords = json[_Keys.coordinates];
    final parsedCoordinates = CoordinatesGeometry.fromDynamic(
      rawCoords,
      geometryType: json[_Keys.geometryType] as String?,
    );

    return Location(
      id: json[_Keys.id] as String,
      name: LocalizedName.fromJson(json),
      type: LocationTypeExtension.fromString(json[_Keys.type] as String),
      description: LocationDescription.fromJson(json),
      elevation: json[_Keys.elevation] as double?,
      geometryType: json[_Keys.geometryType] as String?,
      coordinates: parsedCoordinates,
      gallery: gallery,
    );
  }

  Map<String, dynamic> toJson() {
    // Convert gallery List<String> back to JSON array
    return {
      _Keys.id: id,
      _Keys.name: name.toJson(),
      _Keys.type: type.toJson(),
      _Keys.elevation: elevation,
      _Keys.geometryType: geometryType,
      _Keys.coordinates: coordinates?.toJson(),
      if (gallery != null && gallery!.isNotEmpty) _Keys.gallery: gallery,
      ...description.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    description,
    elevation,
    geometryType,
    coordinates,
    gallery,
  ];
}
