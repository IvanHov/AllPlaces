import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';
import 'package:domain/domain.dart';
import '../../../generated/l10n.dart';
import '../../map/map.dart';

class MapWidget extends StatefulWidget {
  final Location? location;
  final String? locationId;
  final double? size;
  final bool _isTrackMode;

  // Constructor for location-only display
  const MapWidget.fromLocation({super.key, required this.location, this.size})
    : locationId = null,
      _isTrackMode = false;

  // Constructor for track-only display
  const MapWidget.fromTrack({super.key, required this.locationId, this.size})
    : location = null,
      _isTrackMode = true;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<LatLng> trackPoints = [];
  bool isLoadingTrack = true;
  bool hasTrack = false;
  String? trackError;

  @override
  void initState() {
    super.initState();
    if (widget._isTrackMode) {
      _loadGpxTrack();
    } else {
      setState(() {
        hasTrack = false;
        isLoadingTrack = false;
      });
    }
  }

  Future<void> _loadGpxTrack() async {
    if (!widget._isTrackMode || widget.locationId == null) {
      setState(() {
        hasTrack = false;
        isLoadingTrack = false;
      });
      return;
    }

    try {
      final gpxPath = 'assets/tracks/${widget.locationId}.gpx';

      // Check if GPX file exists
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
          setState(() {
            trackPoints = points;
            hasTrack = true;
            isLoadingTrack = false;
          });
        } else {
          setState(() {
            hasTrack = false;
            isLoadingTrack = false;
          });
        }
      } catch (e) {
        setState(() {
          hasTrack = false;
          isLoadingTrack = false;
        });
      }
    } catch (e) {
      setState(() {
        trackError = 'Error loading track: $e';
        hasTrack = false;
        isLoadingTrack = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check what mode we're in and what data is available
    final hasLocationData =
        !widget._isTrackMode &&
        widget.location != null &&
        widget.location!.coordinates != null;

    final hasTrackData = widget._isTrackMode && hasTrack;

    // If no data available for the current mode, return empty widget
    if (!hasLocationData && !hasTrackData) {
      return const SizedBox.shrink();
    }

    // Parse location geometry if we're in location mode
    _LocationGeometry? geometryData;
    if (hasLocationData) {
      geometryData = _parseLocationGeometry();
      if (geometryData == null) {
        return const SizedBox.shrink();
      }
    }

    // Determine the title based on mode
    String titleText;
    if (widget._isTrackMode) {
      titleText = S.of(context).trackRoute;
    } else {
      titleText = S.of(context).locationMap;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
          child: Text(
            titleText,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    widget._isTrackMode && widget.locationId != null
                    ? MapPage(locationId: widget.locationId!)
                    : MapPage(location: widget.location!),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 1.0, // Square aspect ratio (1:1)
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AbsorbPointer(
                  child: FlutterMap(
                    options: _buildMapOptions(geometryData),
                    children: [
                      TileLayer(
                        urlTemplate: MapApiConfig.getTileUrl(
                          MapApiConfig.defaultMapProvider,
                        ),
                        userAgentPackageName: 'com.allplaces.app',
                        maxZoom: 18,
                      ),
                      ..._buildMapLayers(geometryData),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  MapOptions _buildMapOptions(_LocationGeometry? geometryData) {
    if (widget._isTrackMode && hasTrack && trackPoints.isNotEmpty) {
      final trackBounds = _calculateTrackBounds();
      if (trackBounds != null) {
        return MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: trackBounds,
            padding: const EdgeInsets.all(20),
          ),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        );
      }
    }

    if (!widget._isTrackMode && geometryData != null) {
      return MapOptions(
        initialCenter: geometryData.center,
        initialZoom: _calculateZoomLevel(),
      );
    }

    // Fallback to default location
    return const MapOptions(
      initialCameraFit: CameraFit.coordinates(
        coordinates: [LatLng(41.3775, 64.5853)],
      ),
    );
  }

  List<Widget> _buildMapLayers(_LocationGeometry? geometryData) {
    final List<Widget> layers = [];

    // Add geometry layers if in location mode
    if (!widget._isTrackMode && geometryData != null) {
      layers.addAll(geometryData.layers);
    }

    // Add track layers if in track mode
    if (widget._isTrackMode && hasTrack && trackPoints.isNotEmpty) {
      // Add polyline for the track
      layers.add(
        PolylineLayer(
          polylines: [
            Polyline(
              points: trackPoints,
              strokeWidth: 4.0,
              color: Theme.of(context).primaryColor,
              borderStrokeWidth: 6.0,
              borderColor: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      );

      // Add start/end markers for track
      final List<Marker> trackMarkers = [];

      if (trackPoints.isNotEmpty) {
        // Start marker
        trackMarkers.add(
          Marker(
            width: 32,
            height: 32,
            point: trackPoints.first,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.pin_drop, color: Colors.white, size: 16),
            ),
          ),
        );

        // End marker (if different from start)
        if (trackPoints.length > 1) {
          trackMarkers.add(
            Marker(
              width: 32,
              height: 32,
              point: trackPoints.last,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.lock, color: Colors.white, size: 16),
              ),
            ),
          );
        }
      }

      if (trackMarkers.isNotEmpty) {
        layers.add(MarkerLayer(markers: trackMarkers));
      }
    }

    return layers;
  }

  LatLngBounds? _calculateTrackBounds() {
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

  double _calculateZoomLevel() {
    if (widget.location?.geometryType?.toLowerCase() == 'point') {
      return 16.0; // Значительно ближе для точек (было 13.0)
    } else {
      return 14.0; // Ближе для полигонов чтобы лучше видеть детали (было 11.0)
    }
  }

  _LocationGeometry? _parseLocationGeometry() {
    if (widget.location?.coordinates == null) return null;

    try {
      final coords = widget.location!.coordinates;
      if (coords is PointCoords) {
        return _parsePointGeometry(coords);
      } else if (coords is PolygonCoords) {
        return _parsePolygonGeometry(coords);
      } else if (coords is MultiPolygonCoords) {
        return _parseMultiPolygonGeometry(coords);
      }

      return null;
    } catch (e) {
      debugPrint('Error parsing location geometry: $e');
      return null;
    }
  }

  _LocationGeometry _parsePointGeometry(PointCoords coordinates) {
    final point = LatLng(coordinates.lat, coordinates.lng); // lat, lng

    return _LocationGeometry(
      center: point,
      layers: [
        MarkerLayer(
          markers: [
            Marker(
              width: 40,
              height: 40,
              point: point,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.pin_drop,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _LocationGeometry _parsePolygonGeometry(PolygonCoords coordinates) {
    final rings = coordinates.rings;

    if (rings.isEmpty) return _createEmptyGeometry();

    final List<LatLng> points = rings[0]
        .map((coord) => LatLng(coord[1], coord[0])) // lat, lng
        .toList();

    if (points.isEmpty) return _createEmptyGeometry();

    final center = _calculatePolygonCenter(points);

    return _LocationGeometry(
      center: center,
      layers: [
        PolygonLayer(
          polygons: [
            Polygon(
              points: points,
              color: Colors.blue.withValues(alpha: 0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 2,
            ),
          ],
        ),
      ],
    );
  }

  _LocationGeometry _parseMultiPolygonGeometry(MultiPolygonCoords coordinates) {
    // Для MultiPolygon берем первый полигон
    if (coordinates.polygons.isNotEmpty) {
      return _parsePolygonGeometry(
        PolygonCoords(rings: coordinates.polygons.first),
      );
    }
    return _createEmptyGeometry();
  }

  LatLng _calculatePolygonCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);

    double centerLat = 0;
    double centerLng = 0;

    for (final point in points) {
      centerLat += point.latitude;
      centerLng += point.longitude;
    }

    return LatLng(centerLat / points.length, centerLng / points.length);
  }

  _LocationGeometry _createEmptyGeometry() {
    return _LocationGeometry(
      center: const LatLng(41.0, 69.0), // Центр Узбекистана как fallback
      layers: [],
    );
  }
}

class _LocationGeometry {
  final LatLng center;
  final List<Widget> layers;

  _LocationGeometry({required this.center, required this.layers});
}
