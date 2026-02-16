import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/services/isar_service.dart';

class AttendanceLocalRepository {
  final Logger _logger = Logger();
  final IsarService _isarService;

  AttendanceLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Save attendance record
  Future<int> saveAttendance(AttendanceLocal attendance) async {
    return await _isar.writeTxn(() async {
      return await _isar.attendanceLocals.put(attendance);
    });
  }

  /// Get attendance by ID
  Future<AttendanceLocal?> getAttendanceById(int id) async {
    return await _isar.attendanceLocals.get(id);
  }

  /// Get attendance by Server ID (OdId)
  Future<AttendanceLocal?> getAttendanceByOdId(String odId) async {
    return await _isar.attendanceLocals.filter().odIdEqualTo(odId).findFirst();
  }

  /// Get today's attendance for user
  Future<AttendanceLocal?> getTodayAttendance(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await _isar.attendanceLocals
        .filter()
        .userIdEqualTo(userId)
        .checkInTimeBetween(startOfDay, endOfDay)
        .findFirst();
  }

  /// Get attendance history for user
  Future<List<AttendanceLocal>> getAttendanceHistory(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int offset = 0,
  }) async {
    var query = _isar.attendanceLocals.filter().userIdEqualTo(userId);

    if (startDate != null) {
      query = query.checkInTimeGreaterThan(startDate);
    }
    if (endDate != null) {
      query = query.checkInTimeLessThan(endDate);
    }

    var sortedQuery = query.sortByCheckInTimeDesc();

    if (limit != null) {
      return await sortedQuery.offset(offset).limit(limit).findAll();
    }
    return await sortedQuery.offset(offset).findAll();
  }

  /// Get unsynced attendance records
  Future<List<AttendanceLocal>> getUnsyncedAttendance() async {
    return await _isar.attendanceLocals
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  /// Mark attendance as synced
  Future<void> markAttendanceSynced(int id, String serverId) async {
    await _isar.writeTxn(() async {
      final attendance = await _isar.attendanceLocals.get(id);
      if (attendance != null) {
        attendance.isSynced = true;
        attendance.odId = serverId;
        attendance.syncedAt = DateTime.now();
        await _isar.attendanceLocals.put(attendance);
      }
    });
  }

  /// Update checkout time and photo
  Future<void> updateCheckout(
    int id,
    DateTime checkOutTime,
    String? photoPath,
  ) async {
    try {
      await _isar.writeTxn(() async {
        final attendance = await _isar.attendanceLocals.get(id);
        if (attendance != null) {
          attendance.checkOutTime = checkOutTime;
          attendance.updatedAt = DateTime.now();
          if (photoPath != null) {
            attendance.photoOutLocalPath = photoPath;
          }
          attendance.isSynced = false; // Mark for re-sync
          await _isar.attendanceLocals.put(attendance);
        }
      });
    } catch (e) {
      _logger.e('Failed to update checkout in local DB', error: e);
      rethrow;
    }
  }
}
