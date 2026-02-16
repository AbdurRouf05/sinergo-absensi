import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/models/dto/recap_row_model.dart';

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
    required DateTime now, // UTC or Server Time
  }) {
    int present = 0, lateCount = 0, leaveCount = 0, alphaCount = 0;
    List<UserLocal> alphaUsers = [];

    // CACHE CURRENT TIME ONCE
    // Assume 'now' is passed as UTC or reliable server time.
    // Convert to Office Time for comparison (Default WIB/UTC+7 if null)
    // NOTE: Hardcoded to WIB (UTC+7) for competition context.
    // In production, we should pass the Office Model to get the specific timezone.
    final todayOffice = _toOfficeData(now);

    final shiftMap = {for (var s in shifts) s.odId: s};
    final attendanceMap = {for (var a in attendances) a.userId: a};
    final leaveMap = {for (var l in leaves) l.userId: l};

    for (var user in users) {
      final shift = shiftMap[user.shiftOdId];
      if (shift == null ||
          !shift.workDays
              .any((d) => d.toLowerCase().contains(_getDayName(todayOffice)))) {
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
        // ALPHA CHECK: Compare against Shift Start in Office Time
        final shiftParts = shift.startTime.split(':');
        final shiftH = int.parse(shiftParts[0]);
        final shiftM = int.parse(shiftParts[1]);

        // Setup Shift Start DateTime in Office Timezone
        final shiftStart = DateTime(todayOffice.year, todayOffice.month,
            todayOffice.day, shiftH, shiftM);

        // buffer 30 mins before counting as Alpha in dashboard?
        // Or strict? Requirement says "Late" logic.
        // If now > shiftStart, they are Late (if checkin) or Alpha (if not).

        if (todayOffice.isAfter(shiftStart)) {
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
    final nowOffice = _toOfficeData(DateTime.now());

    return users.map((user) {
      final userAtts = allAttendances.where((a) => a.userId == user.odId);
      final userLeaves = allLeaves.where((l) => l.userId == user.odId);

      int present = 0,
          lateCount = 0,
          lateMin = 0,
          overtimeCount = 0,
          overtimeMin = 0,
          alphaCount = 0;

      // 1. Calculate Presence Stats
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

      // 2. Calculate Historical Alpha
      final shift = shiftMap[user.shiftOdId];
      if (shift != null) {
        final days = endDate.difference(startDate).inDays + 1;
        for (var i = 0; i < days; i++) {
          final d = startDate.add(Duration(days: i));

          // Skip Future (Compare d with nowOffice date part)
          if (d.year > nowOffice.year ||
              (d.year == nowOffice.year && d.month > nowOffice.month) ||
              (d.year == nowOffice.year &&
                  d.month == nowOffice.month &&
                  d.day > nowOffice.day)) {
            continue;
          }

          final dayName = _getDayName(d);
          if (!shift.workDays.any((wd) => wd.toLowerCase() == dayName)) {
            continue;
          }

          final isPresent = userAtts.any((a) {
            // Compare purely numeric Date YMD
            final aDate =
                a.checkInTime.toLocal(); // Convert to local for day matching?
            // Ideally we use UTC YMD if stored as UTC date.
            // But checkInTime is DateTime.
            return aDate.year == d.year &&
                aDate.month == d.month &&
                aDate.day == d.day;
          });
          if (isPresent) continue;

          final isLeave = userLeaves.any((l) {
            if (l.startDate == null || l.endDate == null) return false;
            final start = l.startDate!;
            final end = l.endDate!;
            // Check overlapping logic... simplified for direct day match
            return d.compareTo(start) >= 0 && d.compareTo(end) <= 0;
          });
          if (isLeave) continue;

          // If Today: Check shift start time logic
          if (d.year == nowOffice.year &&
              d.month == nowOffice.month &&
              d.day == nowOffice.day) {
            final shiftParts = shift.startTime.split(':');
            final h = int.parse(shiftParts[0]);
            final m = int.parse(shiftParts[1]);
            final shiftStart = DateTime(d.year, d.month, d.day, h, m);

            if (nowOffice.isBefore(shiftStart)) {
              continue; // Not yet alpha
            }
          }

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

  // --- HELPERS ---

  /// Convert any DateTime to fixed Office Timezone (UTC+7 for now)
  static DateTime _toOfficeData(DateTime d) {
    // If d is UTC, add 7 hours.
    // Use explicit offset logic.
    return d.toUtc().add(const Duration(hours: 7));
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
    // Weekday 1=Mon, 7=Sun
    return days[date.weekday - 1];
  }
}
