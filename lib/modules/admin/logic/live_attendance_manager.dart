import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
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

    return {
      'users': users,
      'attendances': attendances,
      'leaves': leaves,
    };
  }

  Map<String, dynamic> calculateStatus({
    required List<UserLocal> users,
    required List<AttendanceLocal> attendances,
    required List<LeaveRequestLocal> leaves,
  }) {
    List<AttendanceMonitorItem> temp = [];
    int h = 0, t = 0, a = 0, i = 0, b = 0; // b = belumAbsen

    final now = DateTime.now();
    // PHASE 6.4: Dynamic threshold — after shift end time = ALPA
    final shiftEndTime =
        DateTime(now.year, now.month, now.day, shiftEndHour, shiftEndMinute);
    final isPastShiftEnd = now.isAfter(shiftEndTime);

    for (var user in users) {
      // Find Attendance for User (using OD_ID)
      final att = attendances.firstWhereOrNull((a) => a.userId == user.odId);

      // Find Leave for User
      final leave = leaves.firstWhereOrNull((l) => l.userId == user.odId);

      AttendanceMonitorItem item;

      if (att != null) {
        bool isLate = _checkIsLate(att.checkInTime);

        item = AttendanceMonitorItem(
          user: user,
          attendance: att,
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
        // PHASE 6.4: DYNAMIC STATUS COLOR
        // Before shift end → Yellow (Belum Absen)
        // After shift end  → Red (Alpha/Alpa)
        final dynamicStatus =
            isPastShiftEnd ? LiveStatus.alpa : LiveStatus.belumAbsen;
        item = AttendanceMonitorItem(
          user: user,
          status: dynamicStatus,
        );
        isPastShiftEnd ? a++ : b++;
      }
      temp.add(item);
    }

    temp.sort((a, b) {
      final nameA = a.user.name;
      final nameB = b.user.name;
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    return {
      'list': temp,
      'stats': {'hadir': h, 'telat': t, 'alpa': a, 'izin': i, 'belumAbsen': b}
    };
  }

  bool _checkIsLate(DateTime checkInLocal) {
    if (checkInLocal.hour > shiftStartHour) return true;
    if (checkInLocal.hour == shiftStartHour &&
        checkInLocal.minute > shiftStartMinute) {
      return true;
    }
    return false;
  }
}
