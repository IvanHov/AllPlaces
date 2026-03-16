import 'package:domain/models/location.dart';
import '../../generated/l10n.dart';

extension LocationTypeLocalization on LocationType {
  String get localizedString {
    switch (this) {
      case LocationType.peak:
        return S.current.locationTypePeak;
      case LocationType.cave:
        return S.current.locationTypeCave;
      case LocationType.lake:
        return S.current.locationTypeLake;
      case LocationType.river:
        return S.current.locationTypeRiver;
      case LocationType.waterfall:
        return S.current.locationTypeWaterfall;
      case LocationType.nationalPark:
        return S.current.locationTypeNationalPark;
      case LocationType.unknown:
        return S.current.locationTypeUnknown;
    }
  }
}
