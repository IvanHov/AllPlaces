import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../common/view_models/collection_view_model.dart';
import '../../../common/view_models/static_collections.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  // final _useCase = GetIt.instance<ExploreLocationsUseCase>();

  ExploreBloc() : super(ExploreLoading()) {
    on<_LoadInitial>(_onLoadInitial);
    add(_LoadInitial());
  }

  Future<void> _onLoadInitial(
    _LoadInitial event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoaded(viewModels: StaticCollections.collections));
    // try {
    //   final collections = await _useCase.collections();
    //   final viewModels = <CollectionViewModel>[];
    //   for (final collection in collections) {
    //     final locations = collection.locationIds
    //         .map((id) => _useCase.location(id))
    //         .where((loc) => loc != null)
    //         .cast<Location>()
    //         .toList();
    //     final collectionViewModel = CollectionViewModel.fromCollection(
    //       collection,
    //       locations,
    //     );
    //     viewModels.add(collectionViewModel);
    //   }
    //   emit(ExploreLoaded(viewModels: StaticCollections.collections));
    // } catch (e) {
    //   emit(ExploreError(e.toString()));
    // }
  }
}
