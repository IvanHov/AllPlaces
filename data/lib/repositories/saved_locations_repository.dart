import 'dart:async';
import 'package:domain/interfaces/saved_locations_repository.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class SavedLocationsRepositoryImpl implements SavedLocationsRepository {
  static const String _storeName = 'saved_locations';
  static const String _dbName = 'saved_locations.db';

  Database? _database;
  late StoreRef<String, Map<String, dynamic>> _store;
  final StreamController<List<String>> _savedLocationIdsController =
      StreamController<List<String>>.broadcast();

  @override
  Future<void> initialize() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final dbPath = path.join(dir.path, _dbName);

    _database = await databaseFactoryIo.openDatabase(dbPath);

    _store = stringMapStoreFactory.store(_storeName);
    _savedLocationIdsController.add(await getSavedLocationIds());
  }

  @override
  Future<void> saveLocation(String locationId) async {
    _ensureDatabaseIsOpen();

    if (!await isSaved(locationId)) {
      final savedIds = await getSavedLocationIds();
      savedIds.add(locationId);
      await _store.record('saved_ids').put(_database!, {'ids': savedIds});
      _savedLocationIdsController.add(savedIds);
    }
  }

  @override
  Future<void> unsaveLocation(String locationId) async {
    _ensureDatabaseIsOpen();

    final savedIds = await getSavedLocationIds();
    savedIds.remove(locationId);
    await _store.record('saved_ids').put(_database!, {'ids': savedIds});
    _savedLocationIdsController.add(savedIds);
  }

  @override
  Future<bool> isSaved(String locationId) async {
    _ensureDatabaseIsOpen();

    final savedIds = await getSavedLocationIds();
    return savedIds.contains(locationId);
  }

  @override
  Future<List<String>> getSavedLocationIds() async {
    _ensureDatabaseIsOpen();

    final record = await _store.record('saved_ids').get(_database!);
    if (record == null) return [];

    final ids = record['ids'] as List<dynamic>?;
    return ids?.map((id) => id as String).toList() ?? [];
  }

  @override
  Stream<List<String>> watchSavedLocationIds() {
    return _savedLocationIdsController.stream;
  }

  @override
  Future<void> dispose() async {
    await _savedLocationIdsController.close();
    await _database?.close();
    _database = null;
  }

  void _ensureDatabaseIsOpen() {
    if (_database == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
  }
}
