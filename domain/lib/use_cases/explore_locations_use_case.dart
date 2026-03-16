import 'package:domain/interfaces/content_repository.dart';
import 'package:domain/models/collection.dart';
import 'package:domain/models/location.dart';

class ExploreLocationsUseCase {
  final ContentRepository contentRepository;

  ExploreLocationsUseCase({required this.contentRepository});

  Future<List<Collection>> collections() {
    return contentRepository.collections();
  }

  Location? location(String id) {
    return contentRepository.getLocationById(id);
  }
}
