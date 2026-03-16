import 'package:flutter/material.dart';
import 'package:domain/models/location.dart';
import '../../../generated/l10n.dart';
import '../../../common/localization/localized_string.dart';

class InfoWidget extends StatelessWidget {
  final Location location;

  const InfoWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrowScreen = constraints.maxWidth < 400;
        final horizontalPadding = isNarrowScreen ? 8.0 : 12.0;
        final containerPadding = isNarrowScreen ? 16.0 : 20.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 12.0,
              ),
              child: Text(
                S.of(context).information,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(containerPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Type
                    Expanded(
                      child: _InfoColumn(
                        title: _getLocalizedTitle(context, 'type'),
                        value: location.type.localizedString,
                        theme: theme,
                        isNarrow: isNarrowScreen,
                      ),
                    ),

                    // Divider with padding
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Container(
                        width: 1,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),

                    // Height
                    Expanded(
                      child: _InfoColumn(
                        title: _getLocalizedTitle(context, 'height'),
                        value: _getElevationText(location.elevation),
                        theme: theme,
                        isNarrow: isNarrowScreen,
                      ),
                    ),

                    // Divider with padding
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Container(
                        width: 1,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),

                    // Difficulty
                    Expanded(
                      child: _InfoColumn(
                        title: _getLocalizedTitle(context, 'difficulty'),
                        value: _getDifficultyText(context, location),
                        theme: theme,
                        isNarrow: isNarrowScreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getLocalizedTitle(BuildContext context, String key) {
    switch (key) {
      case 'type':
        return S.of(context).type;
      case 'height':
        return S.of(context).height;
      case 'difficulty':
        return S.of(context).difficulty;
      default:
        return key;
    }
  }

  String _getElevationText(double? elevation) {
    if (elevation == null) return '—';
    return '${elevation.toInt()}m';
  }

  String _getDifficultyText(BuildContext context, Location location) {
    // Simple logic to determine difficulty based on elevation and type
    final elevation = location.elevation ?? 0;
    final type = location.type;

    String difficulty;
    if (type == LocationType.cave || type == LocationType.lake) {
      difficulty = 'easy';
    } else if (elevation > 3000) {
      difficulty = 'hard';
    } else if (elevation > 1500) {
      difficulty = 'moderate';
    } else {
      difficulty = 'easy';
    }

    switch (difficulty) {
      case 'easy':
        return S.of(context).easy;
      case 'moderate':
        return S.of(context).moderate;
      case 'hard':
        return S.of(context).hard;
      default:
        return difficulty;
    }
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final ThemeData theme;
  final bool isNarrow;

  const _InfoColumn({
    required this.title,
    required this.value,
    required this.theme,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final titleFontSize = isNarrow ? 12.0 : 14.0;
    final valueFontSize = isNarrow ? 16.0 : 18.0;
    final spacing = isNarrow ? 6.0 : 8.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: spacing),
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: isNarrow ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
