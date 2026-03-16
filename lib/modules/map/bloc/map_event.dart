part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapData extends MapEvent {
  final Location? location;
  final String? locationId;

  const LoadMapData({this.location, this.locationId});

  @override
  List<Object?> get props => [location, locationId];
}

class LoadGpxTrack extends MapEvent {
  final String locationId;

  const LoadGpxTrack(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class ChangeMapProvider extends MapEvent {
  final MapProvider mapProvider;

  const ChangeMapProvider(this.mapProvider);

  @override
  List<Object?> get props => [mapProvider];
}
