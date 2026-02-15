import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/dto/recap_row_model.dart';

class AnalyticsState {
  final int totalPresent;
  final int totalLate;
  final int totalLeave;
  final int totalAlpha;
  final List<UserLocal> alphaUsers;

  AnalyticsState({
    required this.totalPresent,
    required this.totalLate,
    required this.totalLeave,
    required this.totalAlpha,
    required this.alphaUsers,
  });
}

class AnalyticsManager {
  static AnalyticsState calculateTodayStats({
    required List<UserLocal> users,
    required List<ShiftLocal> shifts,
    required List<AttendanceLocal> attendances,
    required List<LeaveRequestLocal> leaves,
    required DateTime now,
  }) {
    int present = 0, lateCount = 0, leaveCount = 0, alphaCount = 0;
    List<UserLocal> alphaUsers = [];

    final shiftMap = {for (var s in shifts) s.odId: s};
    final attendanceMap = {for (var a in attendances) a.userId: a};
    final leaveMap = {for (var l in leaves) l.userId: l};

    for (var user in users) {
      final shift = shiftMap[user.shiftOdId];
      if (shift == null ||
          !shift.workDays
              .any((d) => d.toLowerCase().contains(_getDayName(now)))) {
        continue;
      }

      final att = attendanceMap[user.odId];
      final leave = leaveMap[user.odId];

      if (att != null) {
        present++;
        if (att.status == AttendanceStatus.late) lateCount++;
      } else if (leave != null) {
        leaveCount++;
      } else {
        final shiftParts = shift.startTime.split(':');
        final shiftStart = DateTime(now.year, now.month, now.day,
            int.parse(shiftParts[0]), int.parse(shiftParts[1]));

        if (now.isAfter(shiftStart)) {
          alphaCount++;
          alphaUsers.add(user);
        }
      }
    }

    return AnalyticsState(
      totalPresent: present,
      totalLate: lateCount,
      totalLeave: leaveCount,
      totalAlpha: alphaCount,
      alphaUsers: alphaUsers,
    );
  }

  static List<RecapRowModel> calculatePeriodicRecap({
    required List<UserLocal> users,
    required List<ShiftLocal> shifts,
    required List<AttendanceLocal> allAttendances,
    required List<LeaveRequestLocal> allLeaves,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final shiftMap = {for (var s in shifts) s.odId: s};

    return users.map((user) {
      final userAtts = allAttendances.where((a) => a.userId == user.odId);
      final userLeaves = allLeaves.where((l) => l.userId == user.odId);

      int present = 0,
          lateCount = 0,
          lateMin = 0,
          overtimeCount = 0,
          overtimeMin = 0,
          alphaCount = 0;

      // 1. Calculate Presence Stats (from Attendance Records)
      for (var att in userAtts) {
        present++;
        if (att.status == AttendanceStatus.late) {
          lateCount++;
          lateMin += att.lateMinutes ?? 0;
        }
        if (att.isOvertime) {
          overtimeCount++;
          overtimeMin += att.overtimeMinutes ?? 0;
        }
      }

      // 2. Calculate Historical Alpha (Loop Date Range)
      final shift = shiftMap[user.shiftOdId];
      if (shift != null) {
        // Iterate from start to end (Inclusive)
        final days = endDate.difference(startDate).inDays + 1;
        for (var i = 0; i < days; i++) {
          final d = startDate.add(Duration(days: i));
          // Skip Future
          if (d.isAfter(DateTime.now())) continue;

          // Check if Work Day
          final dayName = _getDayName(d);
          if (!shift.workDays.any((wd) => wd.toLowerCase() == dayName)) {
            continue;
          }

          // Check if Present (Attendance exists on this day)
          final isPresent = userAtts.any((a) {
            final aDate = a.checkInTime;
            return aDate.year == d.year &&
                aDate.month == d.month &&
                aDate.day == d.day;
          });
          if (isPresent) continue;

          // Check if Leave (Date falls within leave range)
          final isLeave = userLeaves.any((l) {
            if (l.startDate == null || l.endDate == null) return false;

            // Compare Date only (strip time)
            final start = DateTime(
                l.startDate!.year, l.startDate!.month, l.startDate!.day);
            final end =
                DateTime(l.endDate!.year, l.endDate!.month, l.endDate!.day);
            final curr = DateTime(d.year, d.month, d.day);
            return (curr.isAtSameMomentAs(start) || curr.isAfter(start)) &&
                (curr.isAtSameMomentAs(end) || curr.isBefore(end));
          });
          if (isLeave) continue;

          // If Today: Check shift start time logic (Potential Alpha vs Real Alpha)
          if (d.year == DateTime.now().year &&
              d.month == DateTime.now().month &&
              d.day == DateTime.now().day) {
            final shiftParts = shift.startTime.split(':');
            final h = int.parse(shiftParts[0]);
            final m = int.parse(shiftParts[1]);
            final shiftStart = DateTime(d.year, d.month, d.day, h, m);
            if (DateTime.now().isBefore(shiftStart)) {
              // Not yet alpha (shift hasn't started)
              continue;
            }
          }

          // If we reach here -> ALPHA
          alphaCount++;
        }
      }

      return RecapRowModel(
        userId: user.odId,
        employeeName: user.name,
        totalPresent: present,
        totalLateCount: lateCount,
        totalLateMinutes: lateMin,
        totalOvertimeCount: overtimeCount,
        totalOvertimeMinutes: overtimeMin,
        totalLeave: userLeaves.length,
        totalAlpha: alphaCount,
      );
    }).toList();
  }

  static String _getDayName(DateTime date) {
    const days = [
      'senin',
      'selasa',
      'rabu',
      'kamis',
      'jumat',
      'sabtu',
      'minggu'
    ];
    return days[date.weekday - 1];
  }
}
