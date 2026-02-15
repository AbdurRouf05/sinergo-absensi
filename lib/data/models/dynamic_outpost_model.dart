import 'package:isar/isar.dart';

part 'dynamic_outpost_model.g.dart';

/// Temporary attendance location broadcasted by Admin
@collection
class DynamicOutpostLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? odId; // PocketBase ID

  late String name;

  // Coordinates
  @Index()
  late double lat;

  @Index()
  late double lng;

  // Radius in meters (Default 50m for dynamic)
  double radius = 50.0;

  // Metadata
  late String createdBy; // Admin's User ID

  @Index()
  late DateTime expirationTime;

  bool isActive = true;

  late DateTime createdAt;

  DynamicOutpostLocal();

  @ignore
  bool get isExpired {
    return DateTime.now().isAfter(expirationTime);
  }

  @ignore
  bool get isAvailable {
    return isActive && !isExpired;
  }
}
