import 'package:equatable/equatable.dart';

abstract class SavedLocationsEvent extends Equatable {
  const SavedLocationsEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedLocations extends SavedLocationsEvent {}

class RefreshSavedLocations extends SavedLocationsEvent {}

class RemoveFromSaved extends SavedLocationsEvent {
  final String locationId;

  const RemoveFromSaved(this.locationId);

  @override
  List<Object> get props => [locationId];
}
