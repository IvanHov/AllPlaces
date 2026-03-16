part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoaded extends LocationState {
  final Location location;

  const LocationLoaded(this.location);

  @override
  List<Object> get props => [location];
}
