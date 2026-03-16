import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';
import '../map_api_config.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadMapData>(_onLoadMapData);
    on<LoadGpxTrack>(_onLoadGpxTrack);
    on<ChangeMapProvider>(_onChangeMapProvider);
  }

  Future<void> _onLoadMapData(LoadMapData event, Emitter<MapState> emit) async {
    emit(MapLoading());

    try {
      final isTrackMode = event.locationId != null;
      final isLocationMode = event.location != null;

      if (isTrackMode) {
        // Load GPX track
        add(LoadGpxTrack(event.locationId!));
      } else if (isLocationMode) {
        // Load location data
        final hasLocationData = event.location?.coordinates != null;

        if (hasLocationData) {
          emit(
            MapLoaded(
              location: event.location,
              currentMapProvider: MapApiConfig.defaultMapProvider,
              isLocationMode: true,
            ),
          );
        } else {
          emit(const MapNoData(isTrackMode: false));
        }
      } else {
        emit(const MapError('No location or locationId provided'));
      }
    } catch (e) {
      emit(MapError('Error loading map data: $e'));
    }
  }

  Future<void> _onLoadGpxTrack(
    LoadGpxTrack event,
    Emitter<MapState> emit,
  ) async {
    try {
      final gpxPath = 'assets/tracks/${event.locationId}.gpx';

      try {
        final gpxData = await rootBundle.loadString(gpxPath);
        final gpx = GpxReader().fromString(gpxData);

        final List<LatLng> points = [];

        // Extract track points
        for (final track in gpx.trks) {
          for (final segment in track.trksegs) {
            for (final point in segment.trkpts) {
              if (point.lat != null && point.lon != null) {
                points.add(LatLng(point.lat!, point.lon!));
              }
            }
          }
        }

        // Extract route points if no track points
        if (points.isEmpty) {
          for (final route in gpx.rtes) {
            for (final point in route.rtepts) {
              if (point.lat != null && point.lon != null) {
                points.add(LatLng(point.lat!, point.lon!));
              }
            }
          }
        }

        if (points.isNotEmpty) {
          emit(
            MapLoaded(
              trackPoints: points,
              currentMapProvider: MapApiConfig.defaultMapProvider,
              hasTrack: true,
              isTrackMode: true,
            ),
          );
        } else {
          emit(const MapNoData(isTrackMode: true));
        }
      } catch (e) {
        emit(const MapNoData(isTrackMode: true));
      }
    } catch (e) {
      emit(MapError('Error loading track: $e'));
    }
  }

  Future<void> _onChangeMapProvider(
    ChangeMapProvider event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(currentMapProvider: event.mapProvider));
    }
  }
}
