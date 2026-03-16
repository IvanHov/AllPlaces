import 'package:flutter/material.dart';
import '../../common/widgets/location_image_widget.dart';

class PhotoViewPopup extends StatefulWidget {
  final List<String> imageIds;
  final int initialIndex;
  final String locationName;

  const PhotoViewPopup({
    super.key,
    required this.imageIds,
    required this.initialIndex,
    required this.locationName,
  });

  /// Shows the photo view popup as an overlay
  static void show({
    required BuildContext context,
    required List<String> imageIds,
    required int initialIndex,
    required String locationName,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => PhotoViewPopup(
        imageIds: imageIds,
        initialIndex: initialIndex,
        locationName: locationName,
      ),
    );
  }

  @override
  State<PhotoViewPopup> createState() => _PhotoViewPopupState();
}

class _PhotoViewPopupState extends State<PhotoViewPopup> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.locationName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.imageIds.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.imageIds.length,
          itemBuilder: (context, index) {
            return _buildPhotoView(widget.imageIds[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPhotoView(String imageId) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Hero(
              tag: 'photo_$imageId',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LocationImageWidget(
                  locationId: imageId,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
