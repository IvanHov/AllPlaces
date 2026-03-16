import 'package:domain/models/collection.dart';
import 'package:domain/models/location.dart';
import 'package:domain/models/location_name.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../utils/localization_helper.dart';

class CollectionViewModel extends Equatable {
  final String id;
  final LocalizedName name;
  final List<Location> locations;

  const CollectionViewModel({
    required this.id,
    required this.name,
    required this.locations,
  });

  String getName(BuildContext context) {
    final languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    return name.getByLanguage(languageCode);
  }

  factory CollectionViewModel.fromCollection(
    Collection collection,
    List<Location> locations,
  ) {
    return CollectionViewModel(
      id: collection.id,
      name: collection.name,
      locations: locations,
    );
  }

  @override
  List<Object?> get props => [id, name, locations];
}
