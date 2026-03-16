import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/models/location.dart';
import '../../common/widgets/back_button_widget.dart';
import '../explore/widgets/save_button_widget.dart';
import 'bloc/location_bloc.dart';
import '../../common/widgets/location_image_widget.dart';
import 'widgets/info_widget.dart';
import 'widgets/description_widget.dart';
import 'widgets/gallery_widget.dart';
import '../../common/utils/localization_helper.dart';
import 'widgets/map_widget.dart';

class LocationPage extends StatefulWidget {
  final Location location;

  const LocationPage({super.key, required this.location});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc()..add(LoadLocation(widget.location)),
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoaded) {
            return _buildUI(context, state.location);
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, Location location) {
    final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;
    final currentLanguageCode = LocalizationHelper.getCurrentLanguageCode(
      context,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(location.name.getByLanguage(currentLanguageCode)),

        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.more_vert,
        //       color:
        //           theme.appBarTheme.foregroundColor ??
        //           (isDarkMode ? Colors.white : Colors.black),
        //     ),
        //     onPressed: () {
        //       // Handle menu action
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Column(
            children: [
              // Image Card
              AspectRatio(
                aspectRatio: 3 / 3.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LocationImageWidget(locationId: widget.location.id),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withAlpha(204),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      // Content at bottom
                      Positioned(
                        bottom: 24,
                        left: 24,
                        right: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name.getByLanguage(currentLanguageCode),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: SaveButtonWidget(
                          locationId: widget.location.id,
                          size: 48,
                          iconSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InfoWidget(location: location),
              const SizedBox(height: 16),
              DescriptionWidget(location: location),
              const SizedBox(height: 16),
              GalleryWidget(location: location),
              const SizedBox(height: 16),
              if (location.coordinates != null)
                MapWidget.fromLocation(location: location),
              if (location.coordinates != null) const SizedBox(height: 16),
              MapWidget.fromTrack(locationId: location.id),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
