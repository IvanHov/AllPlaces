import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';

abstract class SavedLocationsState extends Equatable {
  const SavedLocationsState();

  @override
  List<Object> get props => [];
}

class SavedLocationsInitial extends SavedLocationsState {}

class SavedLocationsLoading extends SavedLocationsState {}

class SavedLocationsLoaded extends SavedLocationsState {
  final List<Location> savedLocations;

  const SavedLocationsLoaded({required this.savedLocations});

  @override
  List<Object> get props => [savedLocations];
}

class SavedLocationsEmpty extends SavedLocationsState {}

class SavedLocationsError extends SavedLocationsState {
  final String message;

  const SavedLocationsError(this.message);

  @override
  List<Object> get props => [message];
}
