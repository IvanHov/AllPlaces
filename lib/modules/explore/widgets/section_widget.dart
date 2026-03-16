import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import 'package:go_router/go_router.dart';
import '../../../common/router/route_name.dart';
import '../../../common/view_models/collection_view_model.dart';

import '../../../common/widgets/location_item_widget.dart';
import 'section_name_widget.dart';

class SectionWidget extends StatefulWidget {
  final List<Location> locations;
  final void Function(Location)? onLocationTap;
  final CollectionViewModel collectionViewModel;
  final bool isLast;

  const SectionWidget({
    super.key,
    required this.locations,
    this.onLocationTap,
    required this.collectionViewModel,
    this.isLast = false,
  });

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Сохраняем состояние виджета

  @override
  Widget build(BuildContext context) {
    super.build(context); // Обязательно для AutomaticKeepAliveClientMixin

    return Container(
      margin: EdgeInsets.only(top: 8, bottom: widget.isLast ? 24 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.pushNamed(
              RouteName.collection,
              extra: widget.collectionViewModel,
            ),
            child: SectionNameWidget(
              collectionViewModel: widget.collectionViewModel,
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: widget.locations.length,
              // Увеличиваем кэш для лучшей производительности
              cacheExtent: 1200,
              itemBuilder: (context, index) {
                final location = widget.locations[index];
                return AspectRatio(
                  aspectRatio: 0.80,
                  child: LocationItemWidget(
                    key: ValueKey(
                      location.id,
                    ), // Ключ для идентификации виджета
                    location: location,
                    onTap: widget.onLocationTap != null
                        ? () => widget.onLocationTap!(location)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
