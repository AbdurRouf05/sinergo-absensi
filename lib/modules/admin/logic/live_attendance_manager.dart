import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import '../controllers/live_attendance_controller.dart'
    show LiveStatus, AttendanceMonitorItem;

class LiveAttendanceManager {
  final IIsarService _isarService = Get.find<IIsarService>();

  final int shiftStartHour = 8;
  final int shiftStartMinute = 0;
  final int shiftEndHour = 17; // Default shift end: 17:00
  final int shiftEndMinute = 0;

  /// Load data from Isar (Offline First)
  Future<Map<String, List<dynamic>>> loadFromIsar() async {
    final isar = _isarService.isar;

    // 1. Fetch Users
    final users = await isar.userLocals.where().sortByName().findAll();

    // 2. Fetch Today's Attendance
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final attendances = await isar.attendanceLocals
        .filter()
        .checkInTimeBetween(startOfDay, endOfDay)
        .findAll();

    // 3. Fetch Today's Approved Leaves
    final leaves = await isar.leaveRequestLocals
        .filter()
        .statusEqualTo('approved')
        .and()
        .group((q) => q
            .startDateLessThan(endOfDay, include: true)
            .and()
            .endDateGreaterThan(startOfDay, include: true))
        .findAll();

    // 4. Fetch Shifts
    final shifts = await isar.shiftLocals.where().findAll();

    return {
      'users': users,
      'attendances': attendances,
      'leaves': leaves,
      'shifts': shifts,
    };
  }

  Map<String, dynamic> calculateStatus({
    required List<UserLocal> users,
    required List<AttendanceLocal> attendances,
    required List<LeaveRequestLocal> leaves,
    required List<ShiftLocal> shifts, // Added shifts dependency
  }) {
    List<AttendanceMonitorItem> tempList = [];
    int h = 0, t = 0, a = 0, i = 0, b = 0; // b = belumAbsen

    // Standardize to Office Time (UTC+7 for now)
    final nowOffice = _toOfficeData(DateTime.now());

    // Map shifts for O(1) lookup
    final shiftMap = {for (var s in shifts) s.odId: s};

    for (var user in users) {
      // Find Attendance & Leave
      final att = attendances.firstWhereOrNull((a) => a.userId == user.odId);
      final leave = leaves.firstWhereOrNull((l) => l.userId == user.odId);

      // Determine User's specific shift
      final shift = shiftMap[user.shiftOdId];
      // Default fallback if no shift assigned (e.g. 08:00 - 17:00)
      final startH =
          shift != null ? int.parse(shift.startTime.split(':')[0]) : 8;
      final startM =
          shift != null ? int.parse(shift.startTime.split(':')[1]) : 0;
      final endH = shift != null ? int.parse(shift.endTime.split(':')[0]) : 17;
      final endM = shift != null ? int.parse(shift.endTime.split(':')[1]) : 0;

      final shiftEndTime =
          DateTime(nowOffice.year, nowOffice.month, nowOffice.day, endH, endM);

      final isPastShiftEnd = nowOffice.isAfter(shiftEndTime);

      AttendanceMonitorItem item;

      if (att != null) {
        // Calculate Late based on User's Shift
        // Convert checkInTime (UTC) to Office Time
        final checkInOffice = _toOfficeData(att.checkInTime);
        bool isLate = _checkIsLate(checkInOffice, startH, startM);

        item = AttendanceMonitorItem(
          user: user,
          attendance: att, // Pass full object
          status: isLate ? LiveStatus.telat : LiveStatus.hadir,
          photoUrl: att.photoServerUrl,
        );
        isLate ? t++ : h++;
      } else if (leave != null) {
        item = AttendanceMonitorItem(
          user: user,
          leave: leave,
          status: LiveStatus.izin,
        );
        i++;
      } else {
        // Dynamic Status: Belum Absen (Yellow) vs Alpa (Red)
        // Only mark Alpa if strictly past shift end
        final dynamicStatus =
            isPastShiftEnd ? LiveStatus.alpa : LiveStatus.belumAbsen;

        item = AttendanceMonitorItem(
          user: user,
          status: dynamicStatus,
        );
        isPastShiftEnd ? a++ : b++;
      }
      tempList.add(item);
    }

    tempList.sort((a, b) {
      final nameA = a.user.name;
      final nameB = b.user.name;
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    return {
      'list': tempList,
      'stats': {'hadir': h, 'telat': t, 'alpa': a, 'izin': i, 'belumAbsen': b}
    };
  }

  bool _checkIsLate(DateTime checkInOffice, int limitH, int limitM) {
    if (checkInOffice.hour > limitH) return true;
    if (checkInOffice.hour == limitH && checkInOffice.minute > limitM) {
      return true;
    }
    return false;
  }

  /// Convert to Office Time (UTC+7)
  DateTime _toOfficeData(DateTime d) {
    return d.toUtc().add(const Duration(hours: 7));
  }
}
