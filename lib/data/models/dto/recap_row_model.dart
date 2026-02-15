class RecapRowModel {
  final String userId;
  final String employeeName;
  final int totalPresent;
  final int totalLateCount;
  final int totalLateMinutes;
  final int totalOvertimeCount;
  final int totalOvertimeMinutes;
  final int totalLeave;
  final int totalAlpha;

  RecapRowModel({
    required this.userId,
    required this.employeeName,
    required this.totalPresent,
    required this.totalLateCount,
    required this.totalLateMinutes,
    required this.totalOvertimeCount,
    required this.totalOvertimeMinutes,
    required this.totalLeave,
    required this.totalAlpha,
  });

  String toCsv() {
    return "$employeeName,$totalPresent,$totalLateCount,$totalLateMinutes,$totalOvertimeCount,$totalOvertimeMinutes,$totalLeave,$totalAlpha";
  }

  String toShareText() {
    return "$employeeName | Hadir: $totalPresent, Telat: $totalLateCount (${totalLateMinutes}m), Izin: $totalLeave, Lembur: $totalOvertimeCount (${totalOvertimeMinutes}m), Alpha: $totalAlpha";
  }
}
