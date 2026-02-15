import 'package:isar/isar.dart';

part 'office_location_model.g.dart';

/// Office location for geofencing validation
@collection
class OfficeLocationLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String odId; // PocketBase ID

  late String name;

  // Coordinates
  @Index()
  late double lat;

  @Index()
  late double lng;

  // Geofence radius in meters
  late double radius;

  // Allowed WiFi BSSIDs (comma-separated for Isar)
  String? allowedWifiBssids;

  // Active status
  bool isActive = true;

  // Timestamps
  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? lastSyncAt;

  /// Get list of allowed BSSIDs
  @ignore
  List<String> get bssidList {
    if (allowedWifiBssids == null || allowedWifiBssids!.isEmpty) {
      return [];
    }
    return allowedWifiBssids!
        .split(',')
        .map((e) => e.trim().toUpperCase())
        .toList();
  }

  /// Check if a BSSID is allowed
  bool isBssidAllowed(String bssid) {
    return bssidList.contains(bssid.toUpperCase());
  }
}
