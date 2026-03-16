import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import '../../../common/extensions/location_extensions.dart';

class SearchResultItem extends StatelessWidget {
  final Location item;

  const SearchResultItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withAlpha(20),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Image.asset(_getLocationTypeIcon(item.type), width: 31, height: 31),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.localizedName(context),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  item.getTypeLocalizedString(context),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.titleSmall?.color?.withAlpha(125),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocationTypeIcon(LocationType type) {
    switch (type) {
      case LocationType.peak:
        return 'assets/icons/mountain.png';
      case LocationType.lake:
        return 'assets/icons/lake.png';
      case LocationType.cave:
        return 'assets/icons/cave.png';
      case LocationType.waterfall:
        return 'assets/icons/waterfall.png';
      case LocationType.river:
        return 'assets/icons/river.png';
      case LocationType.nationalPark:
        return 'assets/icons/national_park.png';
      case LocationType.unknown:
        return 'assets/icons/cave.png';
    }
  }
}
