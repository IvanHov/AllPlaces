import 'package:domain/models/location.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../utils/localization_helper.dart';

extension LocationExtensions on Location {
  String localizedName(BuildContext context) {
    final languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    return name.getByLanguage(languageCode);
  }

  String? localizedDescription(BuildContext context) {
    final languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    return description.getByLanguage(languageCode);
  }

  String getTypeLocalizedString(BuildContext context) {
    switch (type) {
      case LocationType.peak:
        return S.of(context).locationTypePeak;
      case LocationType.cave:
        return S.of(context).locationTypeCave;
      case LocationType.lake:
        return S.of(context).locationTypeLake;
      case LocationType.river:
        return S.of(context).locationTypeRiver;
      case LocationType.waterfall:
        return S.of(context).locationTypeWaterfall;
      case LocationType.nationalPark:
        return S.of(context).locationTypeNationalPark;
      case LocationType.unknown:
        return S.of(context).locationTypeUnknown;
    }
  }
}
