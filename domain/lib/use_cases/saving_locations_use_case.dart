import 'package:domain/interfaces/saved_locations_repository.dart';
import 'package:domain/interfaces/content_repository.dart';
import 'package:domain/models/location.dart';

class SavingLocationsUseCase {
  final SavedLocationsRepository savedLocationsRepository;
  final ContentRepository contentRepository;

  SavingLocationsUseCase({
    required this.savedLocationsRepository,
    required this.contentRepository,
  });

  Future<void> saveLocation(String locationId) async {
    await savedLocationsRepository.saveLocation(locationId);
  }

  Future<void> unsaveLocation(String locationId) async {
    await savedLocationsRepository.unsaveLocation(locationId);
  }

  Future<bool> isSaved(String locationId) async {
    return await savedLocationsRepository.isSaved(locationId);
  }

  Future<List<String>> getSavedLocationIds() async {
    return await savedLocationsRepository.getSavedLocationIds();
  }

  Future<List<Location>> getSavedLocations() async {
    final savedIds = await savedLocationsRepository.getSavedLocationIds();
    final savedLocations = <Location>[];

    for (final id in savedIds) {
      final location = contentRepository.getLocationById(id);
      if (location != null) {
        savedLocations.add(location);
      }
    }

    return savedLocations;
  }

  Stream<List<String>> watchSavedLocationIds() {
    return savedLocationsRepository.watchSavedLocationIds();
  }

  Future<void> toggleSaved(String locationId) async {
    final isSaved = await this.isSaved(locationId);
    if (isSaved) {
      await unsaveLocation(locationId);
    } else {
      await saveLocation(locationId);
    }
  }
}
