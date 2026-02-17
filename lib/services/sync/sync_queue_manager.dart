import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/sync_queue_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/models/notification_model.dart';

class SyncQueueManager {
  final Logger _logger = Logger();
  final IIsarService _isarService;
  final IAuthService _authService;

  static const int _maxRetries = 3;

  // Observable state moved here or passed?
  // Better to update external observables or keep internals?
  // Let's passed them via a callback or expose them?
  // Actually, keep state minimal here.

  SyncQueueManager(this._isarService, this._authService);

  /// Process pending sync items
  Future<void> processSyncQueue() async {
    final items = await _isarService.getPendingSyncItems(limit: 10);

    if (items.isEmpty) {
      _logger.i('No pending items to sync');
      return;
    }

    _logger.i('Processing ${items.length} sync items...');

    for (final item in items) {
      await _processSingleItem(item);
    }
  }

  /// Process single sync item with retry logic
  Future<void> _processSingleItem(SyncQueueItem item) async {
    try {
      // Mark as in progress
      item.status = SyncStatus.inProgress;
      await _isarService.updateSyncQueueItem(item);

      // Perform sync based on collection type
      switch (item.collection) {
        case 'attendances':
          await _syncAttendance(item);
          break;
        case 'leave_requests':
          await _syncLeaveRequest(item);
          break;
        case 'notifications':
          await _syncNotification(item);
          break;
        default:
          _logger.w('Unknown collection type: ${item.collection}');
          item.status = SyncStatus.failed;
          item.errorMessage = 'Unknown collection type';
          await _isarService.updateSyncQueueItem(item);
          return;
      }

      // Mark as completed
      item.status = SyncStatus.completed;
      item.completedAt = DateTime.now();
      await _isarService.updateSyncQueueItem(item);

      _logger.i('Synced item ${item.id} successfully');
    } catch (e) {
      _logger.e('Failed to sync item ${item.id}', error: e);

      item.retryCount++;
      item.errorMessage = e.toString();
      item.lastAttemptAt = DateTime.now();

      if (item.retryCount >= _maxRetries) {
        item.status = SyncStatus.failed;
        _logger
            .e('Item ${item.id} marked as FAILED after $_maxRetries retries');
      } else {
        // Items will be retried on next sync cycle
        item.status = SyncStatus.pending; // Back to pending for retry
        _logger.w(
            'Item ${item.id} will retry (attempt ${item.retryCount}/$_maxRetries)');
      }

      await _isarService.updateSyncQueueItem(item);
    }
  }

  /// Sync attendance record to PocketBase
  Future<void> _syncAttendance(SyncQueueItem item) async {
    final attendance = await _isarService.getAttendanceById(item.localId);

    if (attendance == null) {
      throw Exception('Attendance record not found: ${item.localId}');
    }

    if (attendance.isSynced && attendance.checkOutTime != null) {
      _logger.i('Attendance ${item.localId} already fully synced, skipping');
      return;
    }

    // Build request body
    // NOTE: Field names MUST match PocketBase schema
    final body = {
      'user_id': attendance.userId, // FIX: Match PB field name
      'location': attendance.locationId,
      'check_in_time':
          attendance.checkInTime.toUtc().toIso8601String(), // Send UTC to PB
      'is_wifi_verified': attendance.isWifiVerified,
      'wifi_bssid': attendance.wifiBssidUsed,
      'lat': attendance.gpsLat,
      'long': attendance.gpsLong,
      'gps_accuracy': attendance.gpsAccuracy,
      'is_offline_entry': attendance.isOfflineEntry,
      'device_id': attendance.deviceIdUsed,
      'status': attendance.status.name,
      // GANAS (Field Duty)
      'is_ganas': attendance.isGanas,
      'ganas_notes': attendance.ganasNotes,
      // Overtime
      'is_overtime': attendance.isOvertime,
      'overtime_duration': attendance.overtimeMinutes,
      'overtime_note': attendance.overtimeNote,
    };

    if (attendance.checkOutTime != null) {
      body['out_time'] = attendance.checkOutTime!.toUtc().toIso8601String();
      body['out_lat'] = attendance.outLat;
      body['out_long'] = attendance.outLong;
    }

    // Handle Photos
    final List<http.MultipartFile> files = [];
    if (attendance.photoLocalPath != null &&
        attendance.photoLocalPath!.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath(
          'photo', attendance.photoLocalPath!));
    }
    if (attendance.photoOutLocalPath != null &&
        attendance.photoOutLocalPath!.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath(
          'photo_out', attendance.photoOutLocalPath!));
    }

    // Sync to PocketBase
    if (attendance.odId != null) {
      // Update existing record
      await _authService.pb.collection('attendances').update(
            attendance.odId!,
            body: body,
            files: files,
          );
    } else {
      // Create new record
      final record = await _authService.pb
          .collection('attendances')
          .create(body: body, files: files);
      await _isarService.markAttendanceSynced(item.localId, record.id);
    }

    _logger.i('Attendance ${item.localId} synced to server');
  }

  /// Sync leave request update to PocketBase
  Future<void> _syncLeaveRequest(SyncQueueItem item) async {
    final leave = await _isarService.isar.leaveRequestLocals.get(item.localId);

    if (leave == null) {
      throw Exception('Leave record not found: ${item.localId}');
    }

    if (leave.odId == null) {
      throw Exception('Leave record has no server ID (ODID): ${item.localId}');
    }

    // Build update body
    final body = {
      'status': leave.status,
      if (leave.rejectionReason != null)
        'rejection_reason': leave.rejectionReason,
    };

    // Update in PocketBase
    await _authService.pb.collection('leave_requests').update(
          leave.odId!,
          body: body,
        );

    // Mark as synced locally
    await _isarService.isar.writeTxn(() async {
      leave.isSynced = true;
      await _isarService.isar.leaveRequestLocals.put(leave);
    });

    _logger.i('Leave Request ${item.localId} update synced to server');
  }

  /// Sync notification creation to PocketBase
  Future<void> _syncNotification(SyncQueueItem item) async {
    final notif = await _isarService.isar.notificationLocals.get(item.localId);

    if (notif == null) {
      throw Exception('Notification record not found: ${item.localId}');
    }

    if (notif.isSynced && notif.odId != null) {
      _logger.i('Notification ${item.localId} already synced');
      return;
    }

    // Build create body
    final body = {
      'user_id': notif.targetUserId,
      'title': notif.title,
      'message': notif.message,
      'type': notif.type,
      'is_read': notif.isRead,
    };

    // Create in PocketBase
    final record = await _authService.pb.collection('notifications').create(
          body: body,
        );

    // Update local record with server ID and mark synced
    await _isarService.isar.writeTxn(() async {
      notif.odId = record.id;
      notif.isSynced = true;
      await _isarService.isar.notificationLocals.put(notif);
    });

    _logger.i('Notification ${item.localId} created on server');
  }

  Future<int> getPendingCount() async {
    final stats = await _isarService.getSyncQueueStats();
    return stats[SyncStatus.pending] ?? 0;
  }

  /// RECOVERY: Find stuck attendance records and queue them for sync
  /// This recovers checkout data that was created before the queue fix
  Future<int> recoverUnsyncedAttendance() async {
    final unsyncedRecords = await _isarService.getUnsyncedAttendance();

    if (unsyncedRecords.isEmpty) {
      _logger.i('No unsynced attendance records to recover');
      return 0;
    }

    _logger.w(
        'RECOVERY: Found ${unsyncedRecords.length} stuck attendance records');

    int recovered = 0;
    for (final att in unsyncedRecords) {
      // Check if already in queue
      final existingItems = await _isarService.getPendingSyncItems(limit: 100);
      final alreadyQueued = existingItems.any(
        (item) => item.collection == 'attendances' && item.localId == att.id,
      );

      if (alreadyQueued) {
        _logger.i('Record ${att.id} already in queue, skipping');
        continue;
      }

      // Determine operation type
      final operation = att.odId != null
          ? SyncOperation.update // Has server ID = update (checkout)
          : SyncOperation.create; // No server ID = new create

      // Add to queue
      await _isarService.addToSyncQueue(SyncQueueItem()
        ..collection = 'attendances'
        ..localId = att.id
        ..dataJson = '{}'
        ..operation = operation
        ..status = SyncStatus.pending
        ..priority = 1
        ..retryCount = 0
        ..createdAt = DateTime.now());

      _logger.i(
          'RECOVERED: Queued attendance ${att.id} for sync (${operation.name})');
      recovered++;
    }

    return recovered;
  }
}
