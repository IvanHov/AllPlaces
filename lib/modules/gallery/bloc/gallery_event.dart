import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class LoadGallery extends GalleryEvent {
  final List<String> imageIds;
  final String locationName;

  const LoadGallery({required this.imageIds, required this.locationName});

  @override
  List<Object?> get props => [imageIds, locationName];
}

class SelectPhoto extends GalleryEvent {
  final int index;

  const SelectPhoto(this.index);

  @override
  List<Object?> get props => [index];
}
