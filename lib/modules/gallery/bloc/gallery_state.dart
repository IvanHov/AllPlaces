import 'package:equatable/equatable.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<String> imageIds;
  final String locationName;
  final int? selectedIndex;

  const GalleryLoaded({
    required this.imageIds,
    required this.locationName,
    this.selectedIndex,
  });

  GalleryLoaded copyWith({
    List<String>? imageIds,
    String? locationName,
    int? selectedIndex,
  }) {
    return GalleryLoaded(
      imageIds: imageIds ?? this.imageIds,
      locationName: locationName ?? this.locationName,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [imageIds, locationName, selectedIndex];
}
