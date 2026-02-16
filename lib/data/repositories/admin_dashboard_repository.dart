import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/dto/admin_recap_dto.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';

class AdminDashboardRepository {
  final IIsarService _isar = Get.find<IIsarService>();
  final IAuthService _auth = Get.find<IAuthService>();

  /// Get daily recap stats (Present, Late, Absent, Leave)
  /// Optimized for dashboard performance
  Future<AdminRecapDTO> getDailyRecap() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // 1. Fetch Users
    final users = await _isar.isar.userLocals.where().findAll();

    // 2. Fetch Today's Attendance (from server)
    // FIX: Use filter to get actual records
    final attendanceResult =
        await _auth.pb.collection('attendances').getFullList(
              filter:
                  'created >= "${startOfDay.toIso8601String()}" && created <= "${endOfDay.toIso8601String()}" && (status = "present" || status = "late")',
              expand: 'user_id',
            );

    final totalPresent = attendanceResult.length;

    // Convert to Local Models for further processing (e.g., AI)
    final attendanceList = attendanceResult
        .map((r) => AttendanceLocal.fromJson(r.toJson()))
        .toList();

    // 3. Fetch Pending Leaves (Count only)
    final pendingLeaves = await _isar.isar.leaveRequestLocals
        .filter()
        .statusEqualTo('pending')
        .count();

    // 4. Fetch Approved Leaves for Today (BATCH FETCH)
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
    int leave = 0;
    int pendingOvertime = 0;
    int absent = 0;
    List<String> absentNames = [];

    // Aggregates
    int lateCount = 0;
    int totalLateMinutes = 0;
    int overtimeCount = 0;
    int totalOvertimeMinutes = 0;
    int ganasCount = 0;

    // Map for quick attendance lookup
    final attMap = {for (var a in attendanceList) a.userId: a};

    pendingOvertime = attendanceList
        .where((a) => a.status == AttendanceStatus.pendingReview)
        .length;

    for (var att in attendanceList) {
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

    // Fix: Users logic needs to be robust against empty attendanceList if needed
    // But here we iterate users to find absent ones
    for (var user in users) {
      if (attMap.containsKey(user.odId)) {
        // user is present
      } else if (usersOnLeave.contains(user.odId)) {
        leave++;
      } else {
        absent++;
        absentNames.add(user.name);
      }
    }

    return AdminRecapDTO(
      totalPresent: totalPresent, // count from DB // count from DB
      totalLeave: leave,
      totalPending: pendingLeaves,
      totalPendingOvertime: pendingOvertime,
      totalAbsent: absent,
      absentEmployeeNames: absentNames,
      todaysAttendance: attendanceList, // Passed correctly
      lateCount: lateCount,
      totalLateMinutes: totalLateMinutes,
      overtimeCount: overtimeCount,
      totalOvertimeMinutes: totalOvertimeMinutes,
      ganasCount: ganasCount,
    );
  }

  // Fetch updated employee list from server
  Future<List<UserLocal>> fetchEmployeesFromServer() async {
    try {
      final records = await _auth.pb.collection('users').getFullList(
            sort: '-created',
          );

      final employees = <UserLocal>[];
      for (var r in records) {
        try {
          employees.add(UserLocal.fromRecord(r));
        } catch (e) {
          debugPrint('⚠️ Error parsing user ${r.id}: $e');
        }
      }
      return employees;
    } catch (e) {
      debugPrint('❌ Failed to fetch employees: $e');
      return await _isar.isar.userLocals.where().findAll();
    }
  }

  // Added to satisfy IAdminRepository interface via AdminRepository facade
  Future<List<UserLocal>> getAllEmployees(
      {int? limit, int offset = 0, String? searchQuery}) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Use Filter for Search
      var q = _isar.isar.userLocals
          .filter()
          .group((g) => g
              .nameContains(searchQuery, caseSensitive: false)
              .or()
              .emailContains(searchQuery, caseSensitive: false))
          .sortByName();

      if (limit != null) {
        return await q.offset(offset).limit(limit).findAll();
      }
      return await q.findAll();
    } else {
      // Use Where for direct scan (efficient)
      var q = _isar.isar.userLocals.where().sortByName();
      if (limit != null) {
        return await q.offset(offset).limit(limit).findAll();
      }
      return await q.findAll();
    }
  }
}
