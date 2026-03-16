import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/models/location.dart';
import '../../common/utils/localization_helper.dart';
import 'bloc/gallery_bloc.dart';
import 'bloc/gallery_event.dart';
import 'bloc/gallery_state.dart';
import 'photo_view_popup.dart';
import 'widgets/gallery_photo_item.dart';
import '../../common/widgets/back_button_widget.dart';

class GalleryPage extends StatelessWidget {
  final Location location;

  const GalleryPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final currentLanguageCode = LocalizationHelper.getCurrentLanguageCode(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(6.0),
          child: BackButtonWidget(),
        ),
        title: Text(location.name.getByLanguage(currentLanguageCode)),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => GalleryBloc()
          ..add(
            LoadGallery(
              imageIds: location.gallery ?? [],
              locationName: location.name.getByLanguage(currentLanguageCode),
            ),
          ),
        child: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            if (state is GalleryLoaded) {
              return _buildGalleryGrid(context, state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(BuildContext context, GalleryLoaded state) {
    if (state.imageIds.isEmpty) {
      return const Center(
        child: Text(
          'No photos available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return GalleryPhotoItem(
                imageId: state.imageIds[index],
                onTap: () => _openPhotoView(
                  context,
                  state.imageIds,
                  index,
                  state.locationName,
                ),
              );
            }, childCount: state.imageIds.length),
          ),
        ],
      ),
    );
  }

  void _openPhotoView(
    BuildContext context,
    List<String> imageIds,
    int initialIndex,
    String locationName,
  ) {
    PhotoViewPopup.show(
      context: context,
      imageIds: imageIds,
      initialIndex: initialIndex,
      locationName: locationName,
    );
  }
}
