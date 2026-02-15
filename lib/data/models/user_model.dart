import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';

part 'user_model.g.dart';

/// User model for local Isar database
@collection
class UserLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String odId; // PocketBase ID

  @Index(unique: true)
  late String email;

  late String name;

  // Office relation (PocketBase ID)
  String? officeOdId;

  // Shift relation (PocketBase ID)
  String? shiftOdId;

  String? registeredDeviceId;

  String? department;

  @Enumerated(EnumType.name)
  late UserRole role;

  List<String>? allowedOfficeIds;

  String? avatarUrl;

  // Shift configuration
  int? shiftId; // Link to ShiftLocal.id

  // Temporary / Display fields (Non-Isar) to safely hold extracted data
  @ignore
  String? debugShiftName;
  @ignore
  String? debugOfficeName;

  // Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;
  DateTime? lastSyncAt;

  // Sync status
  bool isSynced = true;

  UserLocal();

  // FIX: CRASH PROOF PARSING (Paranoid Mode)
  factory UserLocal.fromRecord(RecordModel record) {
    final data = record.data;

    // Helper to safely extract names/strings from expand or data
    String getSafeString(String key, {String defaultVal = ""}) {
      return data[key]?.toString() ?? defaultVal;
    }

    // Helper for relations (Expand > Data > Null)
    String? getSafeRelationId(String key) {
      final items = record.get<List<RecordModel>>('expand.$key');
      if (items.isNotEmpty) {
        return items.first.id;
      }
      return data[key]?.toString();
    }

    String getSafeExpandName(String key, String defaultVal) {
      final items = record.get<List<RecordModel>>('expand.$key');
      if (items.isNotEmpty) {
        return items.first.data['name']?.toString() ?? defaultVal;
      }
      return defaultVal;
    }

    // Defensive parsing for Role
    UserRole parseRole(String? roleStr) {
      if (roleStr == null) return UserRole.employee;
      switch (roleStr.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'hr':
          return UserRole.hr;
        default:
          return UserRole.employee;
      }
    }

    return UserLocal()
      ..odId = record.id
      ..email = (() {
        final e = getSafeString('email');
        return e.isNotEmpty ? e : 'missing_${record.id}@local.placeholder';
      })()
      ..name = getSafeString('name', defaultVal: "Unnamed User")
      ..registeredDeviceId = getSafeString('registered_device_id')
      ..department = getSafeString('department', defaultVal: "-")
      ..avatarUrl = data['avatar']?.toString() // Allow null, UI handles it

      // Relations
      ..shiftOdId = getSafeRelationId('shift')
      ..officeOdId = (() {
        // Handle office_id as Multiple (List) or Single (String)
        final raw = data['office_id'];
        if (raw is List && raw.isNotEmpty) return raw.first.toString();
        if (raw is String && raw.isNotEmpty) return raw;
        return null;
      })()

      // Debug/Display Names
      ..debugShiftName = getSafeExpandName('shift', 'Regular Shift')
      ..debugOfficeName = getSafeExpandName('office_id', 'Kantor Pusat')
      ..role = parseRole(data['role']?.toString())
      ..allowedOfficeIds = (() {
        // Merge office_id (Multiple) and allowed_office_ids (Legacy)
        final Set<String> ids = {};

        // 1. Check office_id (Primary source now)
        final rawOffice = data['office_id'];
        if (rawOffice is List) {
          ids.addAll(rawOffice.map((e) => e.toString()));
        } else if (rawOffice is String && rawOffice.isNotEmpty) {
          ids.add(rawOffice);
        }

        // 2. Check allowed_office_ids (Legacy/Backup)
        final rawAllowed = data['allowed_office_ids'];
        if (rawAllowed is List) {
          ids.addAll(rawAllowed.map((e) => e.toString()));
        }

        return ids.toList();
      })()
      ..createdAt =
          DateTime.tryParse(record.get<String>('created')) ?? DateTime.now()
      ..updatedAt =
          DateTime.tryParse(record.get<String>('updated')) ?? DateTime.now()
      ..lastSyncAt = DateTime.now()
      ..isSynced = true;
  }
}

/// User roles enum
enum UserRole { employee, hr, admin }

/// Extension for UserRole display
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.employee:
        return 'Karyawan';
      case UserRole.hr:
        return 'HR';
      case UserRole.admin:
        return 'Administrator';
    }
  }
}
