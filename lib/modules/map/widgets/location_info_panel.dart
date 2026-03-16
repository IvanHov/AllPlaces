import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../../../common/utils/localization_helper.dart';
import '../../../generated/l10n.dart';
import '../../../common/localization/localized_string.dart';

class LocationInfoPanel extends StatelessWidget {
  final Location location;

  const LocationInfoPanel({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    final localizedName = location.name.getByLanguage(languageCode);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location name
                    Text(
                      localizedName.isNotEmpty
                          ? localizedName
                          : S.of(context).locationTypeUnknown,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Location details row
                    Row(
                      children: [
                        // Elevation
                        if (location.elevation != null) ...[
                          _buildInfoChip(
                            context,
                            icon: Icons.terrain,
                            label: '${location.elevation!.toInt()} м',
                            theme: theme,
                          ),
                          const SizedBox(width: 12),
                        ],

                        // Location type
                        Expanded(
                          child: _buildInfoChip(
                            context,
                            icon: _getTypeIcon(location.type),
                            label: location.type.localizedString,
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(LocationType type) {
    switch (type) {
      case LocationType.peak:
        return Icons.terrain;
      case LocationType.cave:
        return Icons.landscape;
      case LocationType.lake:
        return Icons.water;
      case LocationType.river:
        return Icons.waves;
      case LocationType.nationalPark:
        return Icons.park;
      case LocationType.waterfall:
        return Icons.water_drop;
      case LocationType.unknown:
        return Icons.place;
    }
  }
}
