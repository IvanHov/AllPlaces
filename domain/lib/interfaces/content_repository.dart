import 'package:domain/domain.dart';

abstract interface class ContentRepository {
  Future<void> initialize(); // System
  Future<void> dispose(); // System

  // Location methods
  Future<void> importLocations(String jsonData);
  Future<bool> get hasLocationsInHive;
  Future<void> loadLocationsFromHive();
  Location? getLocationById(String id);
  Future<List<Location>> getAllLocations();

  // Collection methods
  Future<void> importCollections(String jsonData);
  Future<List<Collection>> collections();
  Future<Collection?> getCollectionById(String id);
}
