import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import '../bloc/saved_locations_bloc.dart';
import '../bloc/saved_locations_event.dart';
import '../bloc/saved_locations_state.dart';
import '../../../common/widgets/location_item_widget.dart';
import '../../../generated/l10n.dart';
import '../../../common/widgets/main_button_widget.dart';

class SavedLocationsSection extends StatefulWidget {
  final Function(Location)? onLocationTap;

  const SavedLocationsSection({super.key, this.onLocationTap});

  @override
  State<SavedLocationsSection> createState() => _SavedLocationsSectionState();
}

class _SavedLocationsSectionState extends State<SavedLocationsSection> {
  SavedLocationsBloc? _bloc;
  StreamSubscription<List<String>>? _savedLocationsSubscription;
  final SavingLocationsUseCase _savedLocationsUseCase =
      GetIt.instance<SavingLocationsUseCase>();

  @override
  void initState() {
    super.initState();
    _bloc = SavedLocationsBloc()..add(LoadSavedLocations());
    // Подписываемся на изменения сохраненных локаций
    _savedLocationsSubscription = _savedLocationsUseCase
        .watchSavedLocationIds()
        .listen((_) {
          // Когда изменяются сохраненные локации, обновляем блок
          _bloc?.add(RefreshSavedLocations());
        });
  }

  @override
  void dispose() {
    _savedLocationsSubscription?.cancel();
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc!,
      child: BlocBuilder<SavedLocationsBloc, SavedLocationsState>(
        builder: (context, state) {
          // Показываем секцию только если есть сохраненные локации
          if (state is SavedLocationsEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок секции в стиле ExplorePage
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).savedLocations,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Горизонтальный список локаций
                SizedBox(
                  height: 220,
                  child: _buildLocationsList(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationsList(BuildContext context, SavedLocationsState state) {
    if (state is SavedLocationsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SavedLocationsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).errorLoadingSavedLocations,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            MainButtonWidget(
              text: S.of(context).retry,
              onPressed: () {
                _bloc?.add(LoadSavedLocations());
              },
            ),
          ],
        ),
      );
    }

    if (state is SavedLocationsLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: state.savedLocations.length,
        cacheExtent: 1200,
        itemBuilder: (context, index) {
          final location = state.savedLocations[index];
          return AspectRatio(
            aspectRatio: 0.80,
            child: LocationItemWidget(
              key: ValueKey(location.id),
              location: location,
              onTap: widget.onLocationTap != null
                  ? () => widget.onLocationTap!(location)
                  : null,
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
