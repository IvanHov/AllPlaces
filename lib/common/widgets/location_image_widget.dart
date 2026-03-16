import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/image_cache_config.dart';

/// A reusable widget for displaying location background images from Appwrite storage
/// with optimized caching and error handling.
class LocationImageWidget extends StatelessWidget {
  /// The location ID used to construct the image URL and cache key
  final String locationId;

  /// The fit property for the cached network image
  final BoxFit fit;

  const LocationImageWidget({
    super.key,
    required this.locationId,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    final cacheSize = ImageCacheConfig.getCacheSizeForDevice();
    final imageUrl =
        'https://fra.cloud.appwrite.io/v1/storage/buckets/location_images/files/$locationId/view?project=locations';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: cacheSize.memCacheWidth,
      memCacheHeight: cacheSize.memCacheHeight,
      maxWidthDiskCache: cacheSize.maxWidthDiskCache,
      maxHeightDiskCache: cacheSize.maxHeightDiskCache,
      cacheKey: locationId,
      errorWidget: (context, url, error) {
        debugPrint('Image load error for $locationId: $error');
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}
