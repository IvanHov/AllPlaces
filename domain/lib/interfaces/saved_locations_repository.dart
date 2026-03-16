abstract interface class SavedLocationsRepository {
  Future<void> initialize(); // System
  Future<void> dispose(); // System

  Future<void> saveLocation(String locationId);
  Future<void> unsaveLocation(String locationId);
  Future<bool> isSaved(String locationId);
  Future<List<String>> getSavedLocationIds();
  Stream<List<String>> watchSavedLocationIds();
}
