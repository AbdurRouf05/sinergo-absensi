import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/data/models/dto/admin_recap_dto.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class AdminAnalyticsRepository {
  final IIsarService _isar = Get.find<IIsarService>();
  final IAuthService _auth = Get.find<IAuthService>();

  Future<AdminRecapDTO> getDailyRecap() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // 1. Fetch Users
    final users = await _isar.isar.userLocals.where().findAll();

    // 2. Fetch Today's Attendance
    final attendances = await _isar.isar.attendanceLocals
        .filter()
        .checkInTimeBetween(startOfDay, endOfDay)
        .findAll();

    // 3. Fetch Pending Leaves (Count)
    final pendingLeaves = await _isar.isar.leaveRequestLocals
        .filter()
        .statusEqualTo('pending')
        .count();

    // 4. Fetch Approved Leaves for Today (BATCH FETCH - Fix N+1)
    final approvedLeavesToday = await _isar.isar.leaveRequestLocals
        .filter()
        .statusEqualTo('approved')
        .and()
        .group((q) => q
            .startDateLessThan(endOfDay, include: true)
            .and()
            .endDateGreaterThan(startOfDay, include: true))
        .findAll();

    // Create Set of User IDs on leave for O(1) lookup
    final usersOnLeave = approvedLeavesToday.map((l) => l.userId).toSet();

    // 5. Calculate Stats
    int present = 0;
    int leave = 0;
    int pendingOvertime = 0;
    int absent = 0;
    List<String> absentNames = [];

    // PHASE 6.3: Analytics Aggregates
    int lateCount = 0;
    int totalLateMinutes = 0;
    int overtimeCount = 0;
    int totalOvertimeMinutes = 0;
    int ganasCount = 0;

    // Map for quick attendance lookup
    final attMap = {for (var a in attendances) a.userId: a};

    // Count pending overtime
    pendingOvertime = attendances
        .where((a) => a.status == AttendanceStatus.pendingReview)
        .length;

    // PHASE 6.3: Calculate Late/Overtime/Ganas aggregates
    for (var att in attendances) {
      if (att.status == AttendanceStatus.late) {
        lateCount++;
        totalLateMinutes += att.lateMinutes ?? 0;
      }
      if (att.isOvertime && (att.overtimeMinutes ?? 0) > 0) {
        overtimeCount++;
        totalOvertimeMinutes += att.overtimeMinutes ?? 0;
      }
      if (att.isGanas) {
        ganasCount++;
      }
    }

    // Loop Users (In-Memory Processing)
    for (var user in users) {
      if (attMap.containsKey(user.odId)) {
        present++;
      } else if (usersOnLeave.contains(user.odId)) {
        leave++;
      } else {
        // Not present, not on leave -> Absent (Alpa)
        absent++;
        absentNames.add(user.name);
      }
    }

    return AdminRecapDTO(
      totalPresent: present,
      totalLeave: leave,
      totalPending: pendingLeaves,
      totalPendingOvertime: pendingOvertime,
      totalAbsent: absent,
      absentEmployeeNames: absentNames,
      lateCount: lateCount,
      totalLateMinutes: totalLateMinutes,
      overtimeCount: overtimeCount,
      totalOvertimeMinutes: totalOvertimeMinutes,
      ganasCount: ganasCount,
    );
  }

  Future<Map<String, dynamic>> fetchRawDataLocal(
      DateTime start, DateTime end) async {
    final users = await _isar.isar.userLocals.where().findAll();
    final shifts = await _isar.isar.shiftLocals.where().findAll();
    final attendances = await _isar.isar.attendanceLocals
        .filter()
        .checkInTimeBetween(start, end)
        .findAll();
    final leaves = await _isar.isar.leaveRequestLocals
        .filter()
        .statusEqualTo('approved')
        .and()
        .group((q) => q
            .startDateLessThan(end, include: true)
            .and()
            .endDateGreaterThan(start, include: true))
        .findAll();

    return {
      'users': users,
      'shifts': shifts,
      'attendances': attendances,
      'leaves': leaves,
    };
  }

  // FIX: REMOTE FIRST (Get fresh data directly from server)
  Future<List<UserLocal>> getAllEmployees() async {
    try {
      debugPrint(
          '📋 Admin: Fetching EMPLOYEES from Server (Validating Data)...');

      // 1. Fetch from PocketBase (Fresh Data)
      // Use getFullList - Users collection is usually small enough
      final records = await _auth.pb.collection('users').getFullList(
            sort: '-created',
            // expand: 'shift,office_id', // Optional: if we want relation details
          );

      debugPrint('✅ Employees Fetched: ${records.length}');

      // 2. Map to UserLocal (Uses new paranoid fromRecord)
      final employees = <UserLocal>[];
      for (var r in records) {
        try {
          employees.add(UserLocal.fromRecord(r));
        } catch (e) {
          debugPrint('⚠️ Error parsing user ${r.id}: $e');
          // Add a safe dummy user so UI doesn't break, or just skip
          // Skipping is better than showing broken data
        }
      }

      // 3. Update Local Cache (Optional but good for offline)
      // For now, just return fresh data to fix the crash immediately.
      return employees;
    } catch (e) {
      debugPrint('❌ Failed to fetch employees from server: $e');
      debugPrint('📋 Falling back to Local Isar...');
      Get.snackbar("Offline", "Mengambil data lokal (Server tidak merespon)");
      return await _isar.isar.userLocals.where().findAll();
    }
  }

  /// ADMIN DIRECT FETCH: Fetches leave requests directly from server
  /// Uses TRAWL NET STRATEGY: Fetch ALL, filter client-side
  /// (Server-side filter causes 400 error - documented in journal 2026-02-04)
  Future<List<LeaveRequestLocal>> getLeaveRequestsByStatus(
      String status) async {
    final currentUser = _auth.currentUser.value;
    // FIX: Compare with enum UserRole.admin, not string 'admin'
    final isAdmin = currentUser?.role == UserRole.admin;

    debugPrint('🔍 ADMIN FETCH DEBUG:');
    debugPrint(' - User: ${currentUser?.name}');
    debugPrint(' - User Role: ${currentUser?.role}');
    debugPrint(' - Is Admin: $isAdmin');
    debugPrint(' - Status Filter: $status');

    // ADMIN: Fetch directly from PocketBase (real-time, fresh data)
    if (isAdmin) {
      try {
        debugPrint('📋 Admin: Fetching LEAVES (Safe Mode: getList, top 50)...');

        // 1. Fetch Leaves with getList (Avoids skipTotal=true issue)
        // Sort by start_date desc (created is not sortable on this collection)
        final resultList = await _auth.pb.collection('leave_requests').getList(
              page: 1,
              perPage: 50,
              sort: '-start_date',
            );

        final leaveRecords = resultList.items;
        debugPrint('✅ Leaves Fetched: ${leaveRecords.length}');

        debugPrint('📋 Admin: Fetching USERS (For Name Lookup)...');
        // 2. Fetch Users (Lookup Map) - Safe fetch
        final userResult =
            await _auth.pb.collection('users').getList(page: 1, perPage: 500);
        final userRecords = userResult.items;

        final userMap = {
          for (var u in userRecords)
            u.id: u.data['name']?.toString() ?? 'Unknown'
        };
        debugPrint('✅ Users Fetched: ${userRecords.length}');

        // 3. Client-Side Filter
        final filtered = status == 'all'
            ? leaveRecords
            : leaveRecords.where((r) => r.data['status'] == status).toList();

        debugPrint('📋 Filtered to ${filtered.length} records');

        // 4. Map & Manual Join
        return filtered.map((r) {
          final item = LeaveRequestLocal.fromRecord(r);
          item.odId = r.id; // Critical: Set Remote ID

          // Manual Join: Look up name from userMap using user_id
          final userId = r.data['user_id']?.toString() ?? '';
          item.userName = userMap[userId] ?? 'Unknown User ($userId)';

          debugPrint(
              ' - Mapped: ${item.id} -> ${item.userName} (${item.status})');
          return item;
        }).toList();
      } catch (e) {
        debugPrint('❌ CRITICAL ERROR in Admin Fetch: $e');
        // PREVENT APP CRASH: Return empty list or local data instead of rethrowing
        Get.snackbar("Error Data", "Gagal mengambil data: $e");
        return _getLocalLeaves(status); // Graceful fallback
      }
    }

    // REGULAR USER: Read from local Isar
    debugPrint('📋 Regular user - reading from local Isar');
    return _getLocalLeaves(status);
  }

  /// Fallback: Get leaves from local Isar database
  Future<List<LeaveRequestLocal>> _getLocalLeaves(String status) async {
    if (status == 'all') {
      return await _isar.isar.leaveRequestLocals.where().findAll();
    }
    return await _isar.isar.leaveRequestLocals
        .filter()
        .statusEqualTo(status)
        .findAll();
  }

  /// ADMIN DIRECT FETCH: Fetches attendances directly from server
  Future<List<AttendanceLocal>> getAttendancesByStatus(String status) async {
    final isAdmin = _auth.currentUser.value?.role == UserRole.admin;

    if (isAdmin) {
      try {
        debugPrint('📋 Admin: Fetching ATTENDANCES (Safe Mode)...');
        final resultList = await _auth.pb.collection('attendances').getList(
              page: 1,
              perPage: 100,
              sort: '-created',
            );

        final records = resultList.items;

        // Fetch Users for Name Lookup
        final userResult =
            await _auth.pb.collection('users').getList(page: 1, perPage: 500);
        final userMap = {
          for (var u in userResult.items)
            u.id: u.data['name']?.toString() ?? 'Unknown'
        };

        // Filter
        final filtered = status == 'all'
            ? records
            : records.where((r) => r.data['status'] == status).toList();

        return filtered.map((r) {
          final item = AttendanceLocal.fromJson(r.toJson());
          // Sync ID
          item.odId = r.id;
          // Robust mapping of userId (employee vs user_id)
          final userId =
              (r.data['employee'] ?? r.data['user_id'])?.toString() ?? '';
          item.userId = userId;
          // Map Name using the mapped userId
          item.userName = userMap[userId];
          return item;
        }).toList();
      } catch (e) {
        debugPrint('❌ Error in getAttendancesByStatus: $e');
        return [];
      }
    }
    return [];
  }
}
