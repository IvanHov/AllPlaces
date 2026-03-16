import 'package:domain/interfaces/content_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data/data.dart' as data;
import 'package:get_it/get_it.dart';
import 'common/application.dart';
import 'common/utils/image_cache_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  ImageCacheConfig.configure();

  await data.register(serverUrl: 'http://10.0.2.2:8080');

  runApp(const Application());

  // Запускаем загрузку данных в microtask queue
  Future.microtask(() => initializeLocationData());
}

Future<void> initializeLocationData() async {
  final contentRepo = GetIt.I<ContentRepository>();
  _importLocationsFirstTime(contentRepo);
  // try {
  //   debugPrint('🔍 Checking if locations exist in Hive...');
  //   final contentRepo = GetIt.I<ContentRepository>();
  //   final hasData = await contentRepo.hasLocationsInHive;

  //   if (hasData) {
  //     debugPrint(
  //       '📦 Found existing locations in Hive, loading from storage...',
  //     );
  //     await contentRepo.loadLocationsFromHive();
  //   } else {
  //     debugPrint('📁 No locations in Hive, importing from assets...');
  //     await _importLocationsFirstTime(contentRepo);
  //     debugPrint('✅ First-time import completed');
  //   }
  // } catch (e) {
  //   debugPrint('❌ Error initializing location data: $e');
  // }
}

Future<void> _importLocationsFirstTime(ContentRepository repo) async {
  try {
    debugPrint('🔄 Loading locations.json for first time...');
    final initialDataset = await rootBundle.loadString('assets/locations.json');
    debugPrint('📁 Loaded locations.json');
    await repo.importLocations(initialDataset);
    debugPrint('✅ First-time import to Hive completed');
  } catch (e) {
    debugPrint('❌ Error during first-time import: $e');
    rethrow;
  }
}
