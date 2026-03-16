import 'package:allplaces_client/allplaces_client.dart';
import 'package:data/repositories/content_repository.dart';
import 'package:data/repositories/saved_locations_repository.dart';
import 'package:data/repositories/serverpod_auth_repository.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

/// Registers all dependencies for the data layer.
///
/// Requires [serverUrl] pointing to the Serverpod backend.
///
/// Throws [Exception] if initialization fails
Future<void> register({required String serverUrl}) async {
  final GetIt getIt = GetIt.instance;

  try {
    // Initialize repositories
    final contentRepo = ContentRepositoryImpl();
    final savedLocationsRepo = SavedLocationsRepositoryImpl();

    await contentRepo.initialize();
    await savedLocationsRepo.initialize();

    // Register repositories
    getIt.registerLazySingleton<ContentRepository>(() => contentRepo);
    getIt.registerLazySingleton<SavedLocationsRepository>(
      () => savedLocationsRepo,
    );

    // Initialize auth repository
    final client = Client('$serverUrl/');
    final authRepo = ServerpodAuthRepositoryImpl(client: client);
    getIt.registerLazySingleton<AuthRepository>(() => authRepo);

    // Register use cases
    getIt.registerLazySingleton<AuthUseCase>(() => AuthUseCase(authRepo));
    getIt.registerLazySingleton<ExploreLocationsUseCase>(
      () => ExploreLocationsUseCase(contentRepository: contentRepo),
    );
    getIt.registerLazySingleton<SavingLocationsUseCase>(
      () => SavingLocationsUseCase(
        savedLocationsRepository: savedLocationsRepo,
        contentRepository: contentRepo,
      ),
    );

    // Log success
    print('Dependency injection setup completed successfully.');
  } catch (e) {
    // Clean up on failure
    getIt.reset();
    throw Exception('Failed to initialize dependencies: $e');
  }
}
