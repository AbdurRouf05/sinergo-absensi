import 'package:flutter_test/flutter_test.dart';
import 'package:sinergo_app/modules/admin/logic/analytics_manager.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';

void main() {
  group('AnalyticsManager Tests', () {
    test('calculateTodayStats handles Alpha detection correctly', () {
      final now = DateTime(2026, 2, 6, 10, 0); // 10:00 AM

      final shift = ShiftLocal()
        ..odId = 'shift1'
        ..startTime = '08:00'
        ..workDays = ['senin', 'selasa', 'rabu', 'kamis', 'jumat'];

      final userPresent = UserLocal()
        ..name = 'Hadir User'
        ..odId = 'u1'
        ..shiftOdId = 'shift1';
      final userAlpha = UserLocal()
        ..name = 'Alpha User'
        ..odId = 'u2'
        ..shiftOdId = 'shift1';
      final userLeave = UserLocal()
        ..name = 'Leave User'
        ..odId = 'u3'
        ..shiftOdId = 'shift1';

      final att = AttendanceLocal()
        ..userId = 'u1'
        ..status = AttendanceStatus.present
        ..checkInTime = DateTime(2026, 2, 6, 8, 0);

      final leave = LeaveRequestLocal()
        ..userId = 'u3'
        ..status = 'approved';

      final result = AnalyticsManager.calculateTodayStats(
        users: [userPresent, userAlpha, userLeave],
        shifts: [shift],
        attendances: [att],
        leaves: [leave],
        now: now,
      );

      expect(result.totalPresent, 1);
      expect(result.totalLeave, 1);
      expect(result.totalAlpha, 1);
      expect(result.alphaUsers.first.name, 'Alpha User');
    });

    test('calculatePeriodicRecap aggregates data correctly', () {
      final shift = ShiftLocal()
        ..odId = 'shift1'
        ..name = 'Shift Test'
        ..workDays = [
          'senin',
          'selasa',
          'rabu',
          'kamis',
          'jumat',
          'sabtu',
          'minggu'
        ]
        ..startTime = '08:00';

      final user = UserLocal()
        ..name = 'Karyawan 1'
        ..odId = 'u1'
        ..shiftOdId = 'shift1';

      final atts = [
        AttendanceLocal()
          ..userId = 'u1'
          ..checkInTime = DateTime(2026, 2, 1),
        AttendanceLocal()
          ..userId = 'u1'
          ..checkInTime = DateTime(2026, 2, 2)
          ..isOvertime = true
          ..overtimeMinutes = 60,
      ];

      final results = AnalyticsManager.calculatePeriodicRecap(
        users: [user],
        shifts: [shift],
        allAttendances: atts,
        allLeaves: [],
        startDate: DateTime(2026, 2, 1),
        endDate: DateTime(2026, 2, 2),
      );

      expect(results.first.totalPresent, 2);
      expect(results.first.totalOvertimeMinutes, 60);
    });
  });
}
