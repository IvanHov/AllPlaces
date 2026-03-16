library;

import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

export 'dependency_registry.dart';

Future importLocations(String initialDataSet) async {
  final contentRepo = GetIt.I<ContentRepository>();
  await contentRepo.importLocations(initialDataSet);
}
