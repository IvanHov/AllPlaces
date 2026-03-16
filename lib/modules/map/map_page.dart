import 'dart:math' as math;
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../common/widgets/back_button_widget.dart';
import '../../generated/l10n.dart';
import 'bloc/bloc.dart';
import 'map_api_config.dart';
import 'widgets/location_info_panel.dart';

class MapPage extends StatelessWidget {
  final Location? location;
  final String? locationId;

  const MapPage({super.key, this.location, this.locationId})
    : assert(
        location != null || locationId != null,
        'Either location or locationId must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MapBloc()
            ..add(LoadMapData(location: location, locationId: locationId)),
      child: const _MapPageView(),
    );
  }
}

class _MapPageView extends StatefulWidget {
  const _MapPageView();

  @override
  State<_MapPageView> createState() => _MapPageViewState();
}

class _MapPageViewState extends State<_MapPageView> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, MapState state) {
    final theme = Theme.of(context);

    if (state is MapLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is MapError) {
      return _buildErrorScreen(theme, state.message);
    }

    if (state is MapNoData) {
      return state.isTrackMode
          ? _buildNoTrackScreen(theme)
          : _buildNoLocationScreen(theme);
    }

    if (state is MapLoaded) {
      return _buildMapView(context, state, theme);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMapView(BuildContext context, MapLoaded state, ThemeData theme) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen map
          FlutterMap(
            mapController: _mapController,
            options: _getMapOptions(state),
            children: [
              TileLayer(
                urlTemplate: MapApiConfig.getTileUrl(state.currentMapProvider),
                userAgentPackageName: 'com.allplaces.app',
                maxZoom: 18,
              ),
              ..._getMapLayers(state, theme),
            ],
          ),

          // Top panel with back button and map selector
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  BackButtonWidget(),
                  Spacer(),
                  // Map type selector
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: theme.shadowColor.withValues(alpha: 0.2),
                  //         blurRadius: 8,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //           child: DropdownButton<MapProvider>(
                  //             value: state.currentMapProvider,
                  //             underline: const SizedBox.shrink(),
                  //             icon: const Icon(Icons.map),
                  //             onChanged: (MapProvider? newProvider) {
                  //               if (newProvider != null) {
                  //                 context.read<MapBloc>().add(
                  //                   ChangeMapProvider(newProvider),
                  //                 );
                  //               }
                  //             },
                  //             items:
                  //                 MapProvider.values.map<DropdownMenuItem<MapProvider>>(
                  //                   (MapProvider provider) {
                  //                     return DropdownMenuItem<MapProvider>(
                  //                       value: provider,
                  //                       child: Text(
                  //                         MapApiConfig.mapProviderNames[provider] ??
                  //                             provider.toString(),
                  //                         style: theme.textTheme.bodySmall,
                  //                       ),
                  //                     );
                  //                   },
                  //                 ).toList(),
                  //           ),
                  //         ),
                ],
              ),
            ),
          ),

          // Bottom info panel
          if (state.isLocationMode && state.location != null)
            LocationInfoPanel(location: state.location!),
        ],
      ),
    );
  }

  MapOptions _getMapOptions(MapLoaded state) {
    if (state.isTrackMode && state.trackPoints.isNotEmpty) {
      final bounds = _calculateTrackBounds(state.trackPoints);
      if (bounds != null) {
        return MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(40),
          ),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        );
      }
    }

    if (state.isLocationMode && state.location != null) {
      final geometryData = _parseLocationGeometry(state.location!);
      if (geometryData != null) {
        return MapOptions(
          initialCenter: geometryData.center,
          initialZoom: _calculateZoomLevel(state.location!),
        );
      }
    }

    // Fallback to default location (Uzbekistan)
    return const MapOptions(
      initialCameraFit: CameraFit.coordinates(
        coordinates: [LatLng(41.3775, 64.5853)],
      ),
    );
  }

  List<Widget> _getMapLayers(MapLoaded state, ThemeData theme) {
    final layers = <Widget>[];

    if (state.isTrackMode && state.trackPoints.isNotEmpty) {
      // Add track polyline
      layers.add(
        PolylineLayer(
          polylines: [
            Polyline(
              points: state.trackPoints,
              strokeWidth: 4.0,
              color: theme.primaryColor,
              borderStrokeWidth: 6.0,
              borderColor: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      );

      // Add start and end markers
      layers.add(
        MarkerLayer(
          markers: [
            // Start marker
            Marker(
              width: 40,
              height: 40,
              point: state.trackPoints.first,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            // End marker (only if we have more than one point)
            if (state.trackPoints.length > 1)
              Marker(
                width: 40,
                height: 40,
                point: state.trackPoints.last,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.stop, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      );
    } else if (state.isLocationMode && state.location != null) {
      final geometryData = _parseLocationGeometry(state.location!);
      if (geometryData != null) {
        layers.addAll(geometryData.layers);
      }
    }

    return layers;
  }

  Widget _buildNoTrackScreen(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).trackRoute)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Трек недоступен',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(ThemeData theme, String errorMessage) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).trackRoute)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  LatLngBounds? _calculateTrackBounds(List<LatLng> trackPoints) {
    if (trackPoints.isEmpty) return null;

    double minLat = trackPoints.first.latitude;
    double maxLat = trackPoints.first.latitude;
    double minLng = trackPoints.first.longitude;
    double maxLng = trackPoints.first.longitude;

    for (final point in trackPoints) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  Widget _buildNoLocationScreen(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Координаты недоступны',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _MapGeometryData? _parseLocationGeometry(Location location) {
    try {
      if (location.coordinates == null) {
        return null;
      }
      final coords = location.coordinates!;

      if (coords is PointCoords) {
        final center = LatLng(coords.lat, coords.lng);
        return _MapGeometryData(
          center: center,
          layers: [
            MarkerLayer(
              markers: [
                Marker(
                  width: 32,
                  height: 32,
                  point: center,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      } else if (coords is PolygonCoords) {
        final polygonPoints = coords.rings.first
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();

        double lat = 0, lng = 0;
        for (final point in polygonPoints) {
          lat += point.latitude;
          lng += point.longitude;
        }
        final center = LatLng(
          lat / polygonPoints.length,
          lng / polygonPoints.length,
        );

        return _MapGeometryData(
          center: center,
          layers: [
            PolygonLayer(
              polygons: [
                Polygon(
                  points: polygonPoints,
                  color: Colors.blue.withValues(alpha: 0.3),
                  borderColor: Colors.blue,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
          ],
        );
      }
    } catch (e) {
      debugPrint('Error parsing coordinates: $e');
    }

    return null;
  }

  double _calculateZoomLevel(Location location) {
    if (location.geometryType?.toLowerCase() == 'point') {
      return 17.0; // Closer for points in fullscreen mode
    } else if (location.geometryType?.toLowerCase() == 'polygon') {
      return 14.0; // Closer for polygons
    }
    return 16.0; // Default closer zoom
  }
}

class _MapGeometryData {
  final LatLng center;
  final List<Widget> layers;

  _MapGeometryData({required this.center, required this.layers});
}
