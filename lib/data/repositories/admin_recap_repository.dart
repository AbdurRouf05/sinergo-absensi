import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';

class AdminRecapRepository {
  final IIsarService _isar = Get.find<IIsarService>();
  final IAuthService _auth = Get.find<IAuthService>();

  /// Fetch raw data for generating reports (Isar Local)
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

  /// ADMIN DIRECT FETCH: Leaves by Status
  Future<List<LeaveRequestLocal>> getLeaveRequestsByStatus(
      String status) async {
    final currentUser = _auth.currentUser.value;
    final isAdmin = currentUser?.role == UserRole.admin;

    if (isAdmin) {
      try {
        // Sort by start_date desc
        final resultList = await _auth.pb.collection('leave_requests').getList(
              page: 1,
              perPage: 50,
              sort: '-start_date',
            );

        final leaveRecords = resultList.items;

        // Fetch Users for Name Lookup
        final userResult =
            await _auth.pb.collection('users').getList(page: 1, perPage: 500);

        final userMap = {
          for (var u in userResult.items)
            u.id: u.data['name']?.toString() ?? 'Unknown'
        };

        // Client-Side Filter
        final filtered = status == 'all'
            ? leaveRecords
            : leaveRecords.where((r) => r.data['status'] == status).toList();

        return filtered.map((r) {
          final item = LeaveRequestLocal.fromRecord(r);
          item.odId = r.id;
          final userId = r.data['user_id']?.toString() ?? '';
          item.userName = userMap[userId] ?? 'Unknown User ($userId)';
          return item;
        }).toList();
      } catch (e) {
        debugPrint('❌ CRITICAL ERROR in Admin Fetch: $e');
        return _getLocalLeaves(status);
      }
    }
    return _getLocalLeaves(status);
  }

  Future<List<LeaveRequestLocal>> _getLocalLeaves(String status) async {
    if (status == 'all') {
      return await _isar.isar.leaveRequestLocals.where().findAll();
    }
    return await _isar.isar.leaveRequestLocals
        .filter()
        .statusEqualTo(status)
        .findAll();
  }

  /// ADMIN DIRECT FETCH: Attendances by Status
  Future<List<AttendanceLocal>> getAttendancesByStatus(String status) async {
    final isAdmin = _auth.currentUser.value?.role == UserRole.admin;

    if (isAdmin) {
      try {
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
          item.odId = r.id;
          final userId =
              (r.data['employee'] ?? r.data['user_id'])?.toString() ?? '';
          item.userId = userId;
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
