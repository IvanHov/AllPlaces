import 'package:flutter/material.dart';
import '../../../common/widgets/location_image_widget.dart';

class GalleryPhotoItem extends StatelessWidget {
  final String imageId;
  final VoidCallback onTap;

  const GalleryPhotoItem({
    super.key,
    required this.imageId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Hero(
            tag: 'photo_$imageId',
            child: LocationImageWidget(locationId: imageId, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
