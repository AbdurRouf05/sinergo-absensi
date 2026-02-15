import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/sync_queue_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:http/http.dart' as http;

/// Interface for AttendanceRepository to enable clean mocking in tests
abstract class IAttendanceRepository {
  Future<int> saveAttendanceOffline(AttendanceLocal attendance);
  Future<void> syncToCloud(int localId);
  Future<AttendanceLocal?> getTodayAttendance();
  Future<void> updateAttendance(AttendanceLocal attendance);
}

class AttendanceRepository implements IAttendanceRepository {
  final Logger _logger = Logger();
  final IIsarService _isarService = Get.find<IIsarService>();
  final IAuthService _authService = Get.find<IAuthService>();

  /// Save attendance record locally to Isar
  @override
  Future<int> saveAttendanceOffline(AttendanceLocal attendance) async {
    try {
      _logger.i('Saving attendance offline...');
      final id = await _isarService.saveAttendance(attendance);

      // Also add to sync queue
      await _isarService.addToSyncQueue(SyncQueueItem()
        ..collection = 'attendances' // Fixed collection name
        ..localId = id
        ..dataJson = '{}' // Placeholder for now
        ..operation = SyncOperation.create
        ..status = SyncStatus.pending
        ..priority = 1
        ..retryCount = 0
        ..createdAt = DateTime.now());

      return id;
    } catch (e) {
      _logger.e('Failed to save attendance offline', error: e);
      rethrow;
    }
  }

  /// Trigger immediate sync for a specific record (Fire and Forget)
  @override
  Future<void> syncToCloud(int localId) async {
    try {
      final attendance = await _isarService.getAttendanceById(localId);
      if (attendance == null) return;
      // If fully synced (both In and Out present and synced bit true), skip
      if (attendance.isSynced && attendance.checkOutTime != null) return;

      final isUpdate = attendance.odId !=
          null; // If has Server ID, it's an update (Check-Out)

      final body = {
        'user_id':
            _authService.pb.authStore.record!.id, // FORCE CURRENT USER ID
        'location': attendance.locationId,
        'check_in_time': attendance.checkInTime
            .toUtc()
            .toIso8601String(), // FIX: Send UTC to PB
        'is_wifi_verified': attendance.isWifiVerified,
        'wifi_bssid': attendance.wifiBssidUsed,
        'lat': attendance.gpsLat,
        'long': attendance.gpsLong,
        'gps_accuracy': attendance.gpsAccuracy,
        'is_offline_entry': attendance.isOfflineEntry,
        'device_id': attendance.deviceIdUsed,
        'status': attendance.status.name,
        // GANAS (Field Duty) fields
        'is_ganas': attendance.isGanas,
        'ganas_notes': attendance.ganasNotes,
        // Overtime fields
        'is_overtime': attendance.isOvertime,
        'overtime_duration': attendance.overtimeMinutes,
        'overtime_note': attendance.overtimeNote,
      };

      // ADD OUT DATA IF EXISTS
      if (attendance.checkOutTime != null) {
        body['out_time'] = attendance.checkOutTime!
            .toUtc()
            .toIso8601String(); // FIX: Send UTC to PB
        body['out_lat'] = attendance.outLat;
        body['out_long'] = attendance
            .outLong; // Keep existing naming or verify if it changed too? Assuming out_lat/long kept based on user prompt
      }

      List<http.MultipartFile> files = [];

      // Photo IN
      if (!isUpdate &&
          attendance.photoLocalPath != null &&
          attendance.photoLocalPath!.isNotEmpty) {
        files.add(await http.MultipartFile.fromPath(
            'photo', attendance.photoLocalPath!));
      }

      // Photo OUT
      if (attendance.photoOutLocalPath != null &&
          attendance.photoOutLocalPath!.isNotEmpty) {
        files.add(await http.MultipartFile.fromPath(
            'photo_out', attendance.photoOutLocalPath!));
      }

      _logger
          .i('Syncing attendance $localId to PocketBase (Update=$isUpdate)...');

      if (isUpdate) {
        // UPDATE (PATCH)
        await _authService.pb
            .collection('attendances')
            .update(attendance.odId!, body: body, files: files);
        await _isarService.markAttendanceSynced(localId, attendance.odId!);
        _logger.i('Sync Update successful for $localId.');
      } else {
        // CREATE (POST)
        final record = await _authService.pb
            .collection('attendances')
            .create(body: body, files: files);
        await _isarService.markAttendanceSynced(localId, record.id);
        _logger
            .i('Sync Create successful for $localId. Server ID: ${record.id}');
      }
    } catch (e) {
      _logger.w('Immediate sync failed for $localId, will retry later.',
          error: e);
    }
  }

  @override
  Future<void> updateAttendance(AttendanceLocal attendance) async {
    await _isarService.saveAttendance(attendance);
    // Trigger sync
    syncToCloud(attendance.id);
  }

  /// Get today's attendance for current user
  @override
  Future<AttendanceLocal?> getTodayAttendance() async {
    final user = _authService.currentUser.value;
    if (user == null) return null;
    return await _isarService.getTodayAttendance(user.odId);
  }
}
