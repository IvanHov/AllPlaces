import 'dart:convert';
import 'package:domain/interfaces/content_repository.dart';
import 'package:domain/models/location.dart';
import 'package:domain/models/collection.dart';
import 'package:path/path.dart' as path;
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ContentRepositoryImpl implements ContentRepository {
  static const String _locationsStoreName = 'locations';
  static const String _dbName = 'content.db';

  Database? _database;
  late StoreRef<String, Map<String, dynamic>> _locationsStore;

  Map<String, Location> _locations = {};
  List<Collection> _collections = [];

  @override
  Future<void> initialize() async {
    // Initialize sembast database
    final dir = await path_provider.getApplicationSupportDirectory();
    final dbPath = path.join(dir.path, _dbName);
    _database = await databaseFactoryIo.openDatabase(dbPath);
    _locationsStore = stringMapStoreFactory.store(_locationsStoreName);
  }

  @override
  Future<void> importLocations(String jsonData) async {
    final List<dynamic> locationsJson = jsonDecode(jsonData);
    for (final locationJson in locationsJson) {
      final location = Location.fromJson(locationJson);
      _locations[location.id] = location;
    }
  }

  Future<void> _loadLocationsFromSembast() async {
    _ensureDatabaseIsOpen();

    final records = await _locationsStore.find(_database!);
    if (records.isEmpty) {
      print('📦 Sembast store is empty, locations need to be imported first');
      return;
    }

    final stopwatch = Stopwatch()..start();
    print('🔄 Loading locations from Sembast...');

    _locations = {};
    for (final record in records) {
      final location = Location.fromJson(record.value);
      _locations[location.id] = location;
    }

    stopwatch.stop();
    print(
      '✅ Loaded ${_locations.length} locations from Sembast in ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  @override
  Future<bool> get hasLocationsInHive async {
    _ensureDatabaseIsOpen();
    final count = await _locationsStore.count(_database!);
    return count > 0;
  }

  @override
  Future<void> loadLocationsFromHive() async {
    await _loadLocationsFromSembast();
  }

  @override
  Location? getLocationById(String id) {
    if (_locations.isEmpty) throw Exception('Location repository is empty');
    return _locations[id];
  }

  @override
  Future<List<Location>> getAllLocations() async {
    return _locations.values.toList();
  }

  // Collection methods
  @override
  Future<void> importCollections(String jsonData) async {
    final List<dynamic> collectionsJson = jsonDecode(jsonData);
    _collections = collectionsJson
        .map((json) => Collection.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Collection>> collections() async {
    return _collections;
  }

  @override
  Future<Collection?> getCollectionById(String id) async {
    try {
      return _collections.firstWhere((collection) => collection.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    await _database?.close();
    _database = null;
  }

  void _ensureDatabaseIsOpen() {
    if (_database == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
  }
}
