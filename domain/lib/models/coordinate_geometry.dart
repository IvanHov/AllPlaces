import 'dart:convert';

/// Sealed union for geometry coordinates.
sealed class CoordinatesGeometry {
  const CoordinatesGeometry();

  /// Returns a JSON-serializable representation (arrays, not strings).
  Object toJson();

  static CoordinatesGeometry? fromDynamic(Object? raw, {String? geometryType}) {
    if (raw == null) return null;

    // Handle new format: array of coordinate strings
    if (raw is List) {
      final type = (geometryType ?? '').toLowerCase();

      if (type == 'point') {
        // Expect ["lng,lat"]
        if (raw.isNotEmpty && raw[0] is String) {
          final coordStr = raw[0] as String;
          final parts = coordStr.split(',');
          if (parts.length >= 2) {
            try {
              final lng = double.parse(parts[0]);
              final lat = double.parse(parts[1]);
              return PointCoords(lng: lng, lat: lat);
            } catch (_) {
              return null;
            }
          }
        }
        // Legacy format: [lng, lat] as numbers
        if (raw.length >= 2 && raw[0] is num) {
          final lng = (raw[0] as num).toDouble();
          final lat = (raw[1] as num).toDouble();
          return PointCoords(lng: lng, lat: lat);
        }
        return null;
      }

      if (type == 'polygon') {
        // New format: ["lng,lat", "lng,lat", ...]
        if (raw.isNotEmpty && raw[0] is String) {
          try {
            final coordinates = <List<double>>[];
            for (final coordStr in raw) {
              if (coordStr is String) {
                final parts = coordStr.split(',');
                if (parts.length >= 2) {
                  final lng = double.parse(parts[0]);
                  final lat = double.parse(parts[1]);
                  coordinates.add([lng, lat]);
                }
              }
            }
            if (coordinates.isNotEmpty) {
              return PolygonCoords(rings: [coordinates]);
            }
          } catch (_) {
            return null;
          }
        }
        // Legacy format: [[[lng,lat], ...], ...]
        if (raw.isNotEmpty && raw[0] is List) {
          try {
            final rings = raw
                .map<List<List<double>>>(
                  (ring) => (ring as List)
                      .map<List<double>>(
                        (coord) => (coord as List)
                            .map<double>((v) => (v as num).toDouble())
                            .toList(),
                      )
                      .toList(),
                )
                .toList();
            return PolygonCoords(rings: rings);
          } catch (_) {
            return null;
          }
        }
        return null;
      }
    }

    // Legacy support: coordinates provided as a JSON string.
    Object parsed = raw;
    if (raw is String) {
      try {
        parsed = jsonDecode(raw);
      } catch (_) {
        return null;
      }
    }

    final type = (geometryType ?? '').toLowerCase();

    if (type == 'point') {
      // Expect [lng, lat]
      if (parsed is List && parsed.length >= 2) {
        final lng = (parsed[0] as num).toDouble();
        final lat = (parsed[1] as num).toDouble();
        return PointCoords(lng: lng, lat: lat);
      }
      return null;
    }

    if (type == 'polygon') {
      // Expect [[[lng,lat], ...], ...]
      if (parsed is List) {
        // Validate structure; coerce to doubles
        final rings = parsed
            .map<List<List<double>>>(
              (ring) => (ring as List)
                  .map<List<double>>(
                    (coord) => (coord as List)
                        .map<double>((v) => (v as num).toDouble())
                        .toList(),
                  )
                  .toList(),
            )
            .toList();
        return PolygonCoords(rings: rings);
      }
      return null;
    }

    if (type == 'multipolygon') {
      // Expect [[[[lng,lat], ...], ...], ...]
      if (parsed is List) {
        final polys = parsed
            .map<List<List<List<double>>>>(
              (poly) => (poly as List)
                  .map<List<List<double>>>(
                    (ring) => (ring as List)
                        .map<List<double>>(
                          (coord) => (coord as List)
                              .map<double>((v) => (v as num).toDouble())
                              .toList(),
                        )
                        .toList(),
                  )
                  .toList(),
            )
            .toList();
        return MultiPolygonCoords(polygons: polys);
      }
      return null;
    }

    // If type is unknown, try best-effort detection.
    if (parsed is List) {
      if (parsed.isNotEmpty && parsed[0] is num) {
        // Likely point [lng, lat]
        final lng = (parsed[0] as num).toDouble();
        final lat = (parsed.length > 1 ? parsed[1] as num : 0).toDouble();
        return PointCoords(lng: lng, lat: lat);
      }
      if (parsed.isNotEmpty && parsed[0] is List) {
        // Likely polygon (or multipolygon). Try polygon first.
        try {
          final rings = parsed
              .map<List<List<double>>>(
                (ring) => (ring as List)
                    .map<List<double>>(
                      (coord) => (coord as List)
                          .map<double>((v) => (v as num).toDouble())
                          .toList(),
                    )
                    .toList(),
              )
              .toList();
          return PolygonCoords(rings: rings);
        } catch (_) {
          // Try multipolygon
          try {
            final polys = parsed
                .map<List<List<List<double>>>>(
                  (poly) => (poly as List)
                      .map<List<List<double>>>(
                        (ring) => (ring as List)
                            .map<List<double>>(
                              (coord) => (coord as List)
                                  .map<double>((v) => (v as num).toDouble())
                                  .toList(),
                            )
                            .toList(),
                      )
                      .toList(),
                )
                .toList();
            return MultiPolygonCoords(polygons: polys);
          } catch (_) {
            return null;
          }
        }
      }
    }

    return null;
  }
}

class PointCoords extends CoordinatesGeometry {
  final double lng;
  final double lat;
  const PointCoords({required this.lng, required this.lat});

  @override
  Object toJson() => [lng, lat];
}

class PolygonCoords extends CoordinatesGeometry {
  /// Rings: list of linear rings, each a list of [lng, lat]
  final List<List<List<double>>> rings;
  const PolygonCoords({required this.rings});

  @override
  Object toJson() => rings;
}

class MultiPolygonCoords extends CoordinatesGeometry {
  /// Polygons: list of polygons -> rings -> [lng, lat]
  final List<List<List<List<double>>>> polygons;
  const MultiPolygonCoords({required this.polygons});

  @override
  Object toJson() => polygons;
}
