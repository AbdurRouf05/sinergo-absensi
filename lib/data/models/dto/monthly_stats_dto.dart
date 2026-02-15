/// DTO for holding aggregated monthly statistics
/// Not an entity/database model, just for UI presentation
class MonthlyStatsDTO {
  final double attendancePercentage;
  final int totalLateMinutes;
  final int totalAbsentCount; // Alpa
  final List<EmployeeMonthlySummary> breakdown;

  MonthlyStatsDTO({
    required this.attendancePercentage,
    required this.totalLateMinutes,
    required this.totalAbsentCount,
    required this.breakdown,
  });
}

class EmployeeMonthlySummary {
  final String userId;
  final String employeeName;
  final String? avatarUrl;
  final String jobTitle; // e.g role or department

  final int totalPresent; // Hadir + Telat
  final int totalLateMinutes;
  final int totalLeave; // Izin/Sakit/Cuti
  final int totalAbsent; // Alpa
  final int totalWorkDays; // Denominator (Shift working days)

  // Status List (Optional, for detailed calendar view if needed later)
  // final Map<int, String> dailyStatus; // Day -> Status

  EmployeeMonthlySummary({
    required this.userId,
    required this.employeeName,
    this.avatarUrl,
    this.jobTitle = 'Karyawan',
    required this.totalPresent,
    required this.totalLateMinutes,
    required this.totalLeave,
    required this.totalAbsent,
    required this.totalWorkDays,
  });

  double get attendancePercentage {
    if (totalWorkDays == 0) return 0.0;
    return (totalPresent / totalWorkDays) * 100;
  }
}
