import 'package:logger/logger.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attendance_fusion/data/mappers/user_mapper.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class MasterDataSyncManager {
  final Logger _logger = Logger();
  final IAuthService _authService;
  final IIsarService _isarService;

  MasterDataSyncManager(this._authService, this._isarService);

  /// Sync Master Data (Office Locations, Shifts & Employees for Admin)
  Future<void> syncMasterData() async {
    try {
      _logger.i('Syncing master data (Office Locations & Shifts)...');

      // 1. Sync Office Locations
      final officeRecords =
          await _authService.pb.collection('office_locations').getFullList();
      if (officeRecords.isNotEmpty) {
        final locations =
            officeRecords.map((r) => _mapToLocalLocation(r)).toList();
        await _isarService.saveOfficeLocations(locations);
      }

      // 2. Sync Shifts (Critical for Analytics)
      await syncShifts();

      // 3. If Admin, sync all employees
      if (_authService.isAdmin) {
        await syncEmployees();
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to sync master data', error: e, stackTrace: stackTrace);
    }
  }

  /// Sync all shifts (Critical for status calculation)
  Future<void> syncShifts() async {
    try {
      final records = await _authService.pb.collection('shifts').getFullList();
      _logger.i('Fetched ${records.length} shifts from server');

      final shifts = records.map((r) {
        return ShiftLocal()
          ..odId = r.id
          ..name = r.data['name']?.toString() ?? 'Default Shift'
          ..startTime = r.data['start_time']?.toString() ?? '08:00'
          ..endTime = r.data['end_time']?.toString() ?? '17:00'
          ..graceMinutes = (r.data['grace_minutes'] as num?)?.toInt() ?? 15
          ..workDays = (r.data['work_days'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              ['senin', 'selasa', 'rabu', 'kamis', 'jumat'];
      }).toList();

      await _isarService.saveShifts(shifts);
      _logger.i('Successfully synced ${shifts.length} shifts');
    } catch (e) {
      _logger.e('Failed to sync shifts: $e');
    }
  }

  /// Sync all employees (Admin feature)
  Future<void> syncEmployees({bool isRetry = false}) async {
    try {
      _logger.i('Admin detected: Syncing all employees... (Retry: $isRetry)');

      final records = await _authService.pb.collection('users').getFullList(
            expand: 'office_id,shift',
          );

      _logger.i('Fetched ${records.length} employee records from server');

      final deviceId = _authService.currentUser.value?.registeredDeviceId;

      final users = records.map((r) {
        return UserMapper.mapRecordToUser(
          r,
          deviceId ?? 'sync_generated',
          _authService.pb,
          _isarService,
        );
      }).toList();

      await _isarService.saveUsers(users);
      _logger.i('Successfully synced ${users.length} employees to local DB');
    } catch (e) {
      if (!isRetry && e.toString().contains('Unique index violated')) {
        _logger.w(
            '⚠️ Unique index violation detected. Clearing local users and retrying...');
        await _isarService.clearUsers();
        await syncEmployees(isRetry: true); // Recursive retry
      } else {
        _logger.e('Failed to sync employees (Retry: $isRetry)', error: e);
        rethrow;
      }
    }
  }

  /// Sync Daily Attendance & Leaves (Admin Live Tracker)
  Future<void> syncDailyAttendance() async {
    try {
      _logger.i('Syncing Daily Attendance & Leaves...');

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final filterDate =
          startOfDay.toIso8601String().replaceFirst('T', ' ').split('.')[0];
      // PB format sometimes needs explicit formatting, but standard ISO usually works if comparing string.
      // Better: Use `2023-10-27 00:00:00.000Z` format or just `created >= "2023-10-27 00:00:00"`
      // Safe bet: ISO string.

      // 1. Fetch Today's Attendance
      final attRecords =
          await _authService.pb.collection('attendances').getFullList(
                filter: 'created >= "$filterDate"',
              );

      // 2. Fetch Approved Leaves (Last 30 Days to ensure Analytics is populated)
      final last30Days = now.subtract(const Duration(days: 30));
      final startDateFilter =
          last30Days.toIso8601String(); // ISO format for comparison

      final leaveRecords = await _authService.pb
          .collection('leave_requests')
          .getFullList(
            filter: 'status = "approved" && start_date >= "$startDateFilter"',
          );

      // 3. Map to Locals
      final attendances = attRecords.map((r) {
        return AttendanceLocal.fromJson(r.toJson());
      }).toList();

      final leaves = leaveRecords.map((r) {
        return LeaveRequestLocal.fromRecord(r);
      }).toList();

      // 4. Save to Isar (Batch)
      // We need to use upsert to avoid duplicates if possible, or clear daily?
      // Since we fetch "today's", we can upsert.
      // IDs are Isar auto-increment, but we might want to match by OD_ID.
      // AttendanceLocal has OD_ID.
      // We should check if they exist or just rely on 'put' overwriting if ID matches?
      // Isar IDs are local ints. OD_ID is string.
      // We need to find existing local ID for the OD_ID to update it, or else we create duplicates.
      // Upsert logic needed.

      await _saveDailyData(attendances, leaves);

      _logger.i(
          'Synced ${attendances.length} attendances and ${leaves.length} leaves.');
    } catch (e) {
      _logger.e('Failed to sync daily attendance', error: e);
      rethrow; // Let controller handle UI feedback
    }
  }

  Future<void> _saveDailyData(
      List<AttendanceLocal> attendances, List<LeaveRequestLocal> leaves) async {
    final isar = _isarService.isar;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // 1. Attendance Upsert Strategy:
    // Fetch all existing local records for TODAY to match against incoming.
    // This avoids "anyOf" issues and is performant for daily batches.
    final existingAtts = await isar.attendanceLocals
        .filter()
        .checkInTimeBetween(startOfDay, endOfDay)
        .findAll();

    final attMap = {for (var e in existingAtts) e.odId: e.id};

    for (var att in attendances) {
      if (att.odId != null && attMap.containsKey(att.odId)) {
        att.id = attMap[att.odId]!;
      }
      att.isSynced = true; // From server
    }

    await isar.writeTxn(() async {
      await isar.attendanceLocals.putAll(attendances);
    });

    // 2. Leaves Upsert Strategy:
    // Match by OD_ID (Unique PocketBase ID) to update status (e.g. pending -> approved)
    // instead of depending on status/date filter which misses status changes.
    final incomingLeaveIds =
        leaves.map((e) => e.odId).whereType<String>().toList();

    if (incomingLeaveIds.isNotEmpty) {
      final existingLeaves = await isar.leaveRequestLocals
          .filter()
          .anyOf(incomingLeaveIds, (q, String id) => q.odIdEqualTo(id))
          .findAll();

      final leaveMap = {for (var e in existingLeaves) e.odId: e.id};

      for (var l in leaves) {
        if (l.odId != null && leaveMap.containsKey(l.odId)) {
          l.id = leaveMap[l.odId]!;
        }
        l.isSynced = true;
      }
    }

    await isar.writeTxn(() async {
      await isar.leaveRequestLocals.putAll(leaves);
    });
  }

  OfficeLocationLocal _mapToLocalLocation(RecordModel r) {
    // Handle potential field name variations
    final name = r.data['name'] ?? r.data['hai'] ?? 'Unknown Location';

    return OfficeLocationLocal()
      ..odId = r.id
      ..name = name.toString()
      ..lat = r.getDoubleValue('latitude')
      ..lng = r.getDoubleValue('longitude')
      ..radius = r.getDoubleValue('radius')
      ..allowedWifiBssids = r.getStringValue('bssid_list') // Fixed field name
      ..isActive = r.data['active'] ?? true // Default to true if not exists
      ..createdAt =
          DateTime.tryParse(r.get<String>('created')) ?? DateTime.now()
      ..updatedAt =
          DateTime.tryParse(r.get<String>('updated')) ?? DateTime.now()
      ..lastSyncAt = DateTime.now();
  }
}
