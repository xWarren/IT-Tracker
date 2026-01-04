import 'enum/proximity_level_enum.dart';

extension ProximityLabel on ProximityLevelEnum {
  String get label {
    switch (this) {
      case ProximityLevelEnum.veryNear:
        return "Very Near";
      case ProximityLevelEnum.near:
        return "Near";
      case ProximityLevelEnum.medium:
        return "Medium";
      case ProximityLevelEnum.far:
        return "Far";
      case ProximityLevelEnum.unknown:
      return "Unknown";
    }
  }
}