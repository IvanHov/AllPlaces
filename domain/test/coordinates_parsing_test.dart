import 'dart:convert';
import 'package:test/test.dart';
import 'package:domain/domain.dart';

void main() {
  group('Coordinates parsing', () {
    test('parses point from array', () {
      final jsonMap = {
        'id': '1',
        'type': 'peak',
        'name_uz': 'A',
        'name_ru': 'A',
        'name_en': 'A',
        'description_uz': null,
        'description_ru': null,
        'description_en': null,
        'geometry_type': 'Point',
        'coordinates': [70.0, 40.0],
      };

      final loc = Location.fromJson(jsonMap);
      expect(loc.coordinates, isA<PointCoords>());
      final point = loc.coordinates as PointCoords;
      expect(point.lng, closeTo(70.0, 1e-9));
      expect(point.lat, closeTo(40.0, 1e-9));
    });

    test('parses point from legacy string', () {
      final jsonMap = {
        'id': '2',
        'type': 'peak',
        'name_uz': 'B',
        'name_ru': 'B',
        'name_en': 'B',
        'description_uz': null,
        'description_ru': null,
        'description_en': null,
        'geometry_type': 'Point',
        'coordinates': jsonEncode([66.1, 37.2]),
      };

      final loc = Location.fromJson(jsonMap);
      expect(loc.coordinates, isA<PointCoords>());
      final point = loc.coordinates as PointCoords;
      expect(point.lng, closeTo(66.1, 1e-9));
      expect(point.lat, closeTo(37.2, 1e-9));
    });

    test('parses polygon from array', () {
      final jsonMap = {
        'id': '3',
        'type': 'lake',
        'name_uz': 'C',
        'name_ru': 'C',
        'name_en': 'C',
        'description_uz': null,
        'description_ru': null,
        'description_en': null,
        'geometry_type': 'Polygon',
        'coordinates': [
          [
            [70.0, 40.0],
            [70.1, 40.1],
            [70.2, 40.2],
          ],
        ],
      };

      final loc = Location.fromJson(jsonMap);
      expect(loc.coordinates, isA<PolygonCoords>());
      final poly = loc.coordinates as PolygonCoords;
      expect(poly.rings.length, 1);
      expect(poly.rings[0].length, 3);
      expect(poly.rings[0][0][0], closeTo(70.0, 1e-9));
      expect(poly.rings[0][0][1], closeTo(40.0, 1e-9));
    });

    test('parses point from new string format', () {
      final jsonMap = {
        'id': '4',
        'type': 'peak',
        'name_uz': 'D',
        'name_ru': 'D',
        'name_en': 'D',
        'description_uz': null,
        'description_ru': null,
        'description_en': null,
        'geometry_type': 'Point',
        'coordinates': ['66.7344844,37.8537611'],
      };

      final loc = Location.fromJson(jsonMap);
      expect(loc.coordinates, isA<PointCoords>());
      final point = loc.coordinates as PointCoords;
      expect(point.lng, closeTo(66.7344844, 1e-9));
      expect(point.lat, closeTo(37.8537611, 1e-9));
    });

    test('parses polygon from new string format', () {
      final jsonMap = {
        'id': '5',
        'type': 'lake',
        'name_uz': 'E',
        'name_ru': 'E',
        'name_en': 'E',
        'description_uz': null,
        'description_ru': null,
        'description_en': null,
        'geometry_type': 'Polygon',
        'coordinates': [
          '59.1784358,43.6818238',
          '59.1757321,43.6810557',
          '59.1733289,43.6801711',
          '59.1784358,43.6818238', // Close the polygon
        ],
      };

      final loc = Location.fromJson(jsonMap);
      expect(loc.coordinates, isA<PolygonCoords>());
      final poly = loc.coordinates as PolygonCoords;
      expect(poly.rings.length, 1);
      expect(poly.rings[0].length, 4);
      expect(poly.rings[0][0][0], closeTo(59.1784358, 1e-9));
      expect(poly.rings[0][0][1], closeTo(43.6818238, 1e-9));
      expect(poly.rings[0][1][0], closeTo(59.1757321, 1e-9));
      expect(poly.rings[0][1][1], closeTo(43.6810557, 1e-9));
    });
  });
}
