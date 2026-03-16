import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'saved_locations_event.dart';
import 'saved_locations_state.dart';

class SavedLocationsBloc
    extends Bloc<SavedLocationsEvent, SavedLocationsState> {
  final SavingLocationsUseCase _useCase =
      GetIt.instance<SavingLocationsUseCase>();

  SavedLocationsBloc() : super(SavedLocationsInitial()) {
    on<LoadSavedLocations>(_onLoadSavedLocations);
    on<RefreshSavedLocations>(_onRefreshSavedLocations);
    on<RemoveFromSaved>(_onRemoveFromSaved);
  }

  Future<void> _onLoadSavedLocations(
    LoadSavedLocations event,
    Emitter<SavedLocationsState> emit,
  ) async {
    emit(SavedLocationsLoading());
    try {
      final savedLocations = await _useCase.getSavedLocations();

      if (savedLocations.isEmpty) {
        emit(SavedLocationsEmpty());
      } else {
        emit(SavedLocationsLoaded(savedLocations: savedLocations));
      }
    } catch (e) {
      emit(SavedLocationsError(e.toString()));
    }
  }

  Future<void> _onRefreshSavedLocations(
    RefreshSavedLocations event,
    Emitter<SavedLocationsState> emit,
  ) async {
    try {
      final savedLocations = await _useCase.getSavedLocations();

      if (savedLocations.isEmpty) {
        emit(SavedLocationsEmpty());
      } else {
        emit(SavedLocationsLoaded(savedLocations: savedLocations));
      }
    } catch (e) {
      emit(SavedLocationsError(e.toString()));
    }
  }

  Future<void> _onRemoveFromSaved(
    RemoveFromSaved event,
    Emitter<SavedLocationsState> emit,
  ) async {
    try {
      await _useCase.unsaveLocation(event.locationId);
      add(RefreshSavedLocations());
    } catch (e) {
      emit(SavedLocationsError(e.toString()));
    }
  }
}
