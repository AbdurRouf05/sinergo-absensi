import 'package:logger/logger.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

/// Result of check-in status calculation.
/// Contains both the attendance status AND the raw late minutes (Fairness Logic).
class CheckInStatusResult {
  final AttendanceStatus status;
  final int lateMinutes; // Raw value, never reduced by overtime

  CheckInStatusResult({required this.status, this.lateMinutes = 0});
}

class CheckInStatusHelper {
  final Logger _logger = Logger();
  final IIsarService _isarService;

  CheckInStatusHelper(this._isarService);

  Future<CheckInStatusResult> calculateStatus(DateTime checkTime) async {
    try {
      final user = await _isarService.getCurrentUser();

      // 1. If no shift linked, use default 08:30
      if (user?.shiftOdId == null) {
        final defaultThreshold =
            DateTime(checkTime.year, checkTime.month, checkTime.day, 8, 30);
        if (checkTime.isAfter(defaultThreshold)) {
          final late = checkTime.difference(defaultThreshold).inMinutes;
          return CheckInStatusResult(
              status: AttendanceStatus.late, lateMinutes: late);
        }
        return CheckInStatusResult(status: AttendanceStatus.present);
      }

      // 2. Fetch Shift Data
      final shift = await _isarService.getShiftByOdId(user!.shiftOdId!);
      if (shift == null) {
        return CheckInStatusResult(status: AttendanceStatus.present);
      }

      // 3. Parse Shift Time (e.g., "08:00" or "08.00")
      final separator = shift.startTime.contains(':') ? ':' : '.';
      final parts = shift.startTime.split(separator);
      final startHour = int.tryParse(parts[0]) ?? 8;
      final startMinute =
          (parts.length > 1) ? (int.tryParse(parts[1]) ?? 0) : 0;

      final shiftStart = DateTime(
        checkTime.year,
        checkTime.month,
        checkTime.day,
        startHour,
        startMinute,
      );

      // 4. Apply Grace Period
      final lateThreshold =
          shiftStart.add(Duration(minutes: shift.graceMinutes));

      if (checkTime.isAfter(lateThreshold)) {
        // FAIRNESS: Calculate raw late minutes from SHIFT START (not grace)
        final lateMinutes = checkTime.difference(shiftStart).inMinutes;
        return CheckInStatusResult(
            status: AttendanceStatus.late,
            lateMinutes: lateMinutes > 0 ? lateMinutes : 0);
      }
      return CheckInStatusResult(status: AttendanceStatus.present);
    } catch (e) {
      _logger.e('Error calculating status', error: e);
      return CheckInStatusResult(status: AttendanceStatus.present);
    }
  }
}
