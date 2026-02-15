class AdminRecapDTO {
  final int totalPresent;
  final int totalLeave;
  final int totalPending;
  final int totalPendingOvertime;
  final int totalAbsent;
  final List<String> absentEmployeeNames;

  // PHASE 6.3: Enhanced Analytics (Frequency + Duration)
  final int lateCount; // Berapa KALI telat
  final int totalLateMinutes; // Total MENIT telat
  final int overtimeCount; // Berapa KALI lembur
  final int totalOvertimeMinutes; // Total MENIT lembur
  final int ganasCount; // Berapa KALI tugas luar

  AdminRecapDTO({
    required this.totalPresent,
    required this.totalLeave,
    required this.totalPending,
    required this.totalPendingOvertime,
    required this.totalAbsent,
    required this.absentEmployeeNames,
    this.lateCount = 0,
    this.totalLateMinutes = 0,
    this.overtimeCount = 0,
    this.totalOvertimeMinutes = 0,
    this.ganasCount = 0,
  });
}
