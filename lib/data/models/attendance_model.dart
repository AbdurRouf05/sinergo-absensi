import 'package:isar/isar.dart';

part 'attendance_model.g.dart';

/// Attendance record for local Isar database
@collection
class AttendanceLocal {
  Id id = Isar.autoIncrement;

  AttendanceLocal();

  // Server ID (null if not synced yet)
  String? odId;

  // Foreign keys
  @Index()
  late String userId;

  @ignore
  String? userName; // For UI display

  @ignore
  String? shiftName; // For UI display

  String? locationId;

  // Check-in/out times
  @Index()
  late DateTime checkInTime;

  DateTime? checkOutTime;

  // Location validation
  late bool isWifiVerified;
  String? wifiBssidUsed;
  String? wifiSsidName;

  double? gpsLat;
  double? gpsLong;
  double? gpsAccuracy;

  // Check-out Location
  double? outLat;
  double? outLong;

  // Offline & sync tracking
  @Index()
  late bool isOfflineEntry;

  late String deviceIdUsed;

  // Status
  @Enumerated(EnumType.name)
  late AttendanceStatus status;

  // Late handling
  String? lateReason;
  int? lateMinutes;

  // Photo capture
  String? photoLocalPath;
  String? photoServerUrl;

  // Check-out Photo
  String? photoOutLocalPath;
  String? photoOutServerUrl;

  // GANAS (Field Duty) Mode (Phase 1)
  bool isGanas = false;
  String? ganasNotes;
  bool isGanasApproved = false;

  // Overtime Claim (Phase 2)
  bool isOvertime = false;
  int? overtimeMinutes;
  String? overtimeNote;
  bool isOvertimeApproved = false;

  // Timestamps
  late DateTime createdAt;
  DateTime? updatedAt;
  DateTime? syncedAt;

  // Sync status
  @Index()
  bool isSynced = false;

  int syncRetryCount = 0;
  String? syncError;

  // Computed property: working hours in minutes
  @ignore
  int? get durationInMinutes {
    if (checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime).inMinutes;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': odId,
      'user_id': userId, // FIX: Matched with PB field name (was 'employee')
      'location': locationId,
      'check_in_time': checkInTime.toUtc().toIso8601String(), // Send UTC to PB
      'out_time': checkOutTime?.toUtc().toIso8601String(),
      'is_wifi_verified': isWifiVerified,
      'wifi_bssid': wifiBssidUsed,
      'lat': gpsLat,
      'long': gpsLong,
      'gps_accuracy': gpsAccuracy,
      'out_lat': outLat,
      'out_long': outLong,
      'is_offline_entry': isOfflineEntry,
      'device_id': deviceIdUsed,
      'status': status.name,
      'late_duration': lateMinutes, // FAIRNESS: Raw late minutes
      'late_reason': lateReason,
      'is_ganas': isGanas,
      'ganas_notes': ganasNotes,
      'is_ganas_approved': isGanasApproved,
      'is_overtime': isOvertime,
      'overtime_duration': overtimeMinutes,
      'overtime_note': overtimeNote,
      'is_overtime_approved': isOvertimeApproved,
    };
  }

  factory AttendanceLocal.fromJson(Map<String, dynamic> json) {
    return AttendanceLocal()
      ..odId = json['id'] as String?
      ..userId = (json['employee'] ?? json['user_id']) as String? ?? ''
      ..locationId = json['location'] as String?
      // Use helper for safe parsing
      // 1. Check In Time ambil dari 'created' (karena di DB Anda tidak ada kolom check_in_time)
      ..checkInTime = _tryParseDate(json['created']) ?? DateTime.now()
      // 2. Check Out Time ambil dari 'out_time' (sesuai screenshot DB)
      ..checkOutTime = _tryParseDate(json['out_time'])
      ..isWifiVerified = json['is_wifi_verified'] as bool? ?? false
      ..wifiBssidUsed = json['wifi_bssid'] as String?
      ..gpsLat = (json['lat'] as num?)?.toDouble()
      ..gpsLong = (json['long'] as num?)?.toDouble()
      ..gpsAccuracy = (json['gps_accuracy'] as num?)?.toDouble()
      ..outLat = (json['out_lat'] as num?)?.toDouble()
      ..outLong = (json['out_long'] as num?)?.toDouble()
      ..isOfflineEntry = json['is_offline_entry'] as bool? ?? false
      ..deviceIdUsed = json['device_id'] as String? ?? ''
      ..status = AttendanceStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (json['status'] as String? ?? 'present').toLowerCase(),
        orElse: () => AttendanceStatus.present,
      )
      ..lateMinutes = json['late_duration'] as int?
      ..lateReason = json['late_reason'] as String?
      ..isGanas = json['is_ganas'] as bool? ?? false
      ..ganasNotes = json['ganas_notes'] as String?
      ..isGanasApproved = json['is_ganas_approved'] as bool? ?? false
      ..isOvertime = json['is_overtime'] as bool? ?? false
      ..overtimeMinutes = json['overtime_duration'] as int?
      ..overtimeNote = json['overtime_note'] as String?
      ..isOvertimeApproved = json['is_overtime_approved'] as bool? ?? false
      ..createdAt = _tryParseDate(json['created']) ?? DateTime.now()
      ..updatedAt = _tryParseDate(json['updated']);
  }

  /// Robust Date Parser (Anti-Crash)
  /// Handles null, empty strings, "N/A", and malformed formats gracefully.
  /// Always returns LOCAL time (PocketBase returns UTC with 'Z' suffix).
  static DateTime? _tryParseDate(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    if (str.isEmpty || str == "null" || str == "N/A") return null;
    try {
      return DateTime.parse(str).toLocal(); // FIX: Convert UTC → Local
    } catch (e) {
      return null; // Return null on any parse error
    }
  }
}

/// Attendance status enum
enum AttendanceStatus { present, late, absent, leave, halfDay, pendingReview }

/// Overtime approval status
enum OvertimeStatus { pendingVerification, approved, rejected }

/// Extension for AttendanceStatus display
extension AttendanceStatusExtension on AttendanceStatus {
  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Hadir';
      case AttendanceStatus.late:
        return 'Terlambat';
      case AttendanceStatus.absent:
        return 'Tidak Hadir';
      case AttendanceStatus.leave:
        return 'Cuti';
      case AttendanceStatus.halfDay:
        return 'Setengah Hari';
      case AttendanceStatus.pendingReview:
        return 'Menunggu Review';
    }
  }

  String get emoji {
    switch (this) {
      case AttendanceStatus.present:
        return '✅';
      case AttendanceStatus.late:
        return '⏰';
      case AttendanceStatus.absent:
        return '❌';
      case AttendanceStatus.leave:
        return '🏖️';
      case AttendanceStatus.halfDay:
        return '🌓';
      case AttendanceStatus.pendingReview:
        return '🔍';
    }
  }
}
