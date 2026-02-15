import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class UserMapper {
  static UserLocal mapRecordToUser(RecordModel record, String deviceId,
      PocketBase pb, IIsarService isarService) {
    final data = record.data;

    // Parse Shift (Safe Logic)
    final expand = data['expand'] as Map<String, dynamic>?;
    // FIX: Match 'shift' key from AuthService
    dynamic rawShift = expand?['shift'] ?? expand?['assigned_shift'];

    Map<String, dynamic>? shiftData;
    if (rawShift is List && rawShift.isNotEmpty) {
      shiftData = rawShift.first as Map<String, dynamic>;
    } else if (rawShift is Map<String, dynamic>) {
      shiftData = rawShift;
    }

    _parseAndSaveShift(shiftData, isarService);

    // Use the crash-proof factory
    return UserLocal.fromRecord(record)
      ..registeredDeviceId = deviceId
      ..avatarUrl =
          data['avatar'] != null && data['avatar'].toString().isNotEmpty
              ? pb.files.getUrl(record, data['avatar'].toString()).toString()
              : null
      ..shiftId = null
      ..shiftOdId = shiftData?['id']?.toString()
      ..isSynced = true;
  }

  static void _parseAndSaveShift(
      Map<String, dynamic>? shiftData, IIsarService isarService) {
    if (shiftData == null) return;
    try {
      final shift = ShiftLocal()
        ..odId = shiftData['id']?.toString() ?? ''
        // FIX: Safe parsing for mandatory late strings
        ..name = shiftData['name']?.toString() ?? 'Regular Shift'
        ..startTime = shiftData['start_time']?.toString() ?? '08:00'
        ..endTime = shiftData['end_time']?.toString() ?? '17:00'
        ..graceMinutes = (shiftData['grace_minutes'] is int)
            ? shiftData['grace_minutes']
            : int.tryParse(shiftData['grace_minutes']?.toString() ?? '0') ?? 0;

      isarService.saveShift(shift);
    } catch (e) {
      Logger().e('Error parsing shift', error: e);
    }
  }

  static OfficeLocationLocal? mapOfficeFromRecord(RecordModel record) {
    final data = record.data;
    final expand = data['expand'] as Map<String, dynamic>?;

    if (expand == null || !expand.containsKey('office_id')) return null;

    final rawOffice = expand['office_id'];
    Map<String, dynamic>? officeData;

    if (rawOffice is List && rawOffice.isNotEmpty) {
      officeData = rawOffice.first as Map<String, dynamic>;
    } else if (rawOffice is Map<String, dynamic>) {
      officeData = rawOffice;
    }

    if (officeData != null) {
      return OfficeLocationLocal()
        ..odId = officeData['id']?.toString() ?? ''
        ..name = officeData['name']?.toString() ?? 'Office'
        ..lat = (officeData['latitude'] is num)
            ? (officeData['latitude'] as num).toDouble()
            : double.tryParse(officeData['latitude']?.toString() ?? '0') ?? 0.0
        ..lng = (officeData['longitude'] is num)
            ? (officeData['longitude'] as num).toDouble()
            : double.tryParse(officeData['longitude']?.toString() ?? '0') ?? 0.0
        ..radius = (officeData['radius'] is num)
            ? (officeData['radius'] as num).toDouble()
            : double.tryParse(officeData['radius']?.toString() ?? '50') ?? 50.0
        ..allowedWifiBssids = officeData['allowed_wifi_bssids']?.toString()
        ..isActive = officeData['is_active'] ?? true // bool usually safe
        ..createdAt =
            DateTime.tryParse(officeData['created']?.toString() ?? '') ??
                DateTime.now()
        ..updatedAt = DateTime.tryParse(officeData['updated']?.toString() ?? '')
        ..lastSyncAt = DateTime.now();
    }
    return null;
  }
}
