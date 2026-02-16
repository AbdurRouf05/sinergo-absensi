import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/sync_service.dart';

class HistorySyncManager {
  final Logger _logger = Logger();
  final IAuthService _authService;
  final IIsarService _isarService;

  HistorySyncManager(this._authService, this._isarService);

  /// FEATURE: Sync Down History from Server
  /// Fetches historical data from PocketBase and merges into local DB
  Future<bool> fetchRemoteHistory() async {
    try {
      // 1. Check connectivity
      if (Get.isRegistered<ISyncService>()) {
        if (!Get.find<ISyncService>().isOnline.value) return false;
      }

      final user = _authService.currentUser.value;
      if (user == null) return false;

      _logger.d('Sync Down: Fetching remote history for ${user.odId}...');

      // 2. Fetch from PocketBase - FILTERED by current user only!
      // PRIVACY FIX: Only fetch THIS user's attendance, not everyone's
      final result = await _authService.pb.collection('attendances').getList(
            page: 1,
            perPage: 50,
            filter: 'user_id = "${user.odId}"', // STRICT: Only my records!
            sort: '-created',
          );

      _logger.d('Sync Down: Found ${result.items.length} records on server');

      // 2. Sort MANUALLY in Dart (Client-Side Sorting)
      final records = result.items;
      records.sort((a, b) =>
          b.get<String>('created').compareTo(a.get<String>('created')));

      int newEntries = 0;

      // 3. Smart Merge
      for (final record in records) {
        // Check local existence by OdId (Server ID)
        final localExists = await _isarService.getAttendanceByOdId(record.id);
        if (localExists != null) continue;

        // Map to Local Model - USE ACTUAL user_id from record, not passed userId
        final recordUserId = record.getStringValue('user_id');
        final attendance = _mapRecordToLocal(
            record, recordUserId.isNotEmpty ? recordUserId : user.odId);

        await _isarService.saveAttendance(attendance);
        newEntries++;
      }

      if (newEntries > 0) {
        _logger.i('Sync Down: Merged $newEntries new records.');
        return true; // Data updated
      } else {
        _logger.d('Sync Down: No new records to merge.');
        return false;
      }
    } catch (e) {
      if (e is ClientException) {
        _logger.e('PB Sync Down Error: Body=${e.response}', error: e);
      }
      _logger.e('Sync Down Failed', error: e);
      return false;
    }
  }

  AttendanceLocal _mapRecordToLocal(RecordModel record, String userId) {
    return AttendanceLocal()
      ..odId = record.id
      ..userId = userId
      ..locationId = record.getStringValue('location')
      ..checkInTime =
          DateTime.tryParse(record.getStringValue('check_in_time')) ??
              DateTime.tryParse(record.get<String>('created')) ??
              DateTime.now()
      ..checkOutTime = record.getStringValue('out_time').isNotEmpty
          ? DateTime.tryParse(record.getStringValue('out_time'))
          : null
      ..isWifiVerified = record.getBoolValue('is_wifi_verified')
      ..wifiBssidUsed = record.getStringValue('wifi_bssid')
      ..gpsLat = record.getDoubleValue('lat')
      ..gpsLong = record.getDoubleValue('long')
      ..gpsAccuracy = record.getDoubleValue('gps_accuracy')
      ..outLat = record.getDoubleValue('out_lat')
      ..outLong = record.getDoubleValue('out_long')
      ..isOfflineEntry = record.getBoolValue('is_offline_entry')
      ..deviceIdUsed = record.getStringValue('device_id').isNotEmpty
          ? record.getStringValue('device_id')
          : 'unknown'
      ..status = AttendanceStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            record.getStringValue('status').toLowerCase(),
        orElse: () => AttendanceStatus.present,
      )
      ..isGanas = record.getBoolValue('is_ganas')
      ..ganasNotes = record.getStringValue('ganas_notes')
      ..isOvertime = record.getBoolValue('is_overtime')
      ..overtimeMinutes = record.getIntValue('overtime_duration')
      ..overtimeNote = record.getStringValue('overtime_note')
      ..createdAt =
          DateTime.tryParse(record.get<String>('created')) ?? DateTime.now()
      ..updatedAt = DateTime.tryParse(record.get<String>('updated'))
      ..isSynced = true
      ..syncedAt = DateTime.now();
  }
}
