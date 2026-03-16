part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LoadLocation extends LocationEvent {
  final Location location;

  const LoadLocation(this.location);

  @override
  List<Object> get props => [location];
}
