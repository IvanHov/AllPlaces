import 'package:flutter/material.dart';
import 'package:domain/models/location.dart';
import '../../../generated/l10n.dart';

class DescriptionWidget extends StatelessWidget {
  final Location location;

  const DescriptionWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLanguageCode = _getCurrentLanguageCode(context);
    final descriptionLanguageCode = _getDescriptionLanguageCode(
      currentLanguageCode,
    );

    // Only show if description is available
    if (!location.description.hasDescription) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
          child: Text(
            S.of(context).description,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
          child: Text(
            _getDescriptionText(location, descriptionLanguageCode),
            style: TextStyle(
              fontSize: 15,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String _getCurrentLanguageCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'uz':
        return 'name_uz';
      case 'ru':
        return 'name_ru';
      case 'en':
      default:
        return 'name_en';
    }
  }

  String _getDescriptionLanguageCode(String langCode) {
    switch (langCode) {
      case 'name_uz':
        return 'uz';
      case 'name_ru':
        return 'ru';
      case 'name_en':
      default:
        return 'en';
    }
  }

  String _getDescriptionText(Location location, String languageCode) {
    // Try to get description in the current language
    final description = location.description.getByLanguage(languageCode);
    if (description != null && description.isNotEmpty) {
      return description;
    }

    // Fallback to English if current language description is not available
    final englishDescription = location.description.getByLanguage('en');
    if (englishDescription != null && englishDescription.isNotEmpty) {
      return englishDescription;
    }

    // Fallback to Russian if English is not available
    final russianDescription = location.description.getByLanguage('ru');
    if (russianDescription != null && russianDescription.isNotEmpty) {
      return russianDescription;
    }

    // Fallback to Uzbek as last resort
    final uzbekDescription = location.description.getByLanguage('uz');
    if (uzbekDescription != null && uzbekDescription.isNotEmpty) {
      return uzbekDescription;
    }

    return '';
  }
}
