import 'package:flutter/material.dart';
import 'package:domain/models/location.dart';
import '../../../common/widgets/location_image_widget.dart';
import '../../gallery/gallery_page.dart';
import '../../../generated/l10n.dart';

class GalleryWidget extends StatelessWidget {
  final Location location;

  const GalleryWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Don't show gallery if no photos
    if (location.gallery == null || location.gallery!.isEmpty) {
      return const SizedBox.shrink();
    }

    final gallery = location.gallery!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              S.of(context).gallery,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Gallery grid
          GestureDetector(
            onTap: () => _openGalleryView(context),
            child: SizedBox(
              height: 320, // Fixed height for the gallery
              child: _buildGalleryGrid(gallery),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid(List<String> gallery) {
    if (gallery.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Large image on the left (takes 2/3 of the width)
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildGalleryImage(gallery[0], isLarge: true),
          ),
        ),
        const SizedBox(width: 8),
        // Stack of smaller images on the right (takes 1/3 of the width)
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (gallery.length > 1) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildGalleryImage(gallery[1], isLarge: false),
                  ),
                ),
              ],
              if (gallery.length > 2 && gallery.length > 1) ...[
                const SizedBox(height: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildGalleryImage(gallery[2], isLarge: false),
                  ),
                ),
              ],
              // If there are more than 3 images, show a "more" overlay on the last image
              if (gallery.length > 3) ...[
                const SizedBox(height: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildGalleryImage(gallery[2], isLarge: false),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(153),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              '+${gallery.length - 3}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(String imageId, {required bool isLarge}) {
    return LocationImageWidget(locationId: imageId, fit: BoxFit.cover);
  }

  void _openGalleryView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GalleryPage(location: location)),
    );
  }
}
