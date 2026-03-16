part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

final class MapLoaded extends MapState {
  final Location? location;
  final List<LatLng> trackPoints;
  final MapProvider currentMapProvider;
  final bool hasTrack;
  final bool isTrackMode;
  final bool isLocationMode;

  const MapLoaded({
    this.location,
    this.trackPoints = const [],
    required this.currentMapProvider,
    this.hasTrack = false,
    this.isTrackMode = false,
    this.isLocationMode = false,
  });

  @override
  List<Object?> get props => [
    location,
    trackPoints,
    currentMapProvider,
    hasTrack,
    isTrackMode,
    isLocationMode,
  ];

  MapLoaded copyWith({
    Location? location,
    List<LatLng>? trackPoints,
    MapProvider? currentMapProvider,
    bool? hasTrack,
    bool? isTrackMode,
    bool? isLocationMode,
  }) {
    return MapLoaded(
      location: location ?? this.location,
      trackPoints: trackPoints ?? this.trackPoints,
      currentMapProvider: currentMapProvider ?? this.currentMapProvider,
      hasTrack: hasTrack ?? this.hasTrack,
      isTrackMode: isTrackMode ?? this.isTrackMode,
      isLocationMode: isLocationMode ?? this.isLocationMode,
    );
  }
}

final class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

final class MapNoData extends MapState {
  final bool isTrackMode;

  const MapNoData({required this.isTrackMode});

  @override
  List<Object?> get props => [isTrackMode];
}
