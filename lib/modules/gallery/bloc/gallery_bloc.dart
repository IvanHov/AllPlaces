import 'package:flutter_bloc/flutter_bloc.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc() : super(GalleryInitial()) {
    on<LoadGallery>(_onLoadGallery);
    on<SelectPhoto>(_onSelectPhoto);
  }

  void _onLoadGallery(LoadGallery event, Emitter<GalleryState> emit) {
    emit(
      GalleryLoaded(imageIds: event.imageIds, locationName: event.locationName),
    );
  }

  void _onSelectPhoto(SelectPhoto event, Emitter<GalleryState> emit) {
    if (state is GalleryLoaded) {
      final currentState = state as GalleryLoaded;
      emit(currentState.copyWith(selectedIndex: event.index));
    }
  }
}
