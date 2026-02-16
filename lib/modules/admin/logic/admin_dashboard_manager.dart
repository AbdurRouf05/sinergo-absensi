import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/repositories/admin_dashboard_repository.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';

class AdminDashboardManager {
  final IAuthService _authService = Get.find<IAuthService>();
  final AdminDashboardRepository _adminRepo =
      Get.find<AdminDashboardRepository>();
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> fetchStats() async {
    final pb = _authService.pb;
    int totalEmployees = 0;
    int pendingLeaves = 0;
    int pendingOvertime = 0;
    int presentToday = 0;
    int leaveToday = 0;
    int alpaToday = 0;
    List<String> absentEmployees = [];
    List<AttendanceLocal> todaysAttendanceList = []; // NEW

    // 1. Total Employees
    final usersResult = await pb.collection('users').getList(perPage: 1);
    totalEmployees = usersResult.totalItems;

    // 2. DAILY RECAP (ALPA Logic)
    try {
      final recap = await _adminRepo.getDailyRecap();
      presentToday = recap.totalPresent;
      leaveToday = recap.totalLeave;
      pendingLeaves = recap.totalPending;
      pendingOvertime = recap.totalPendingOvertime;
      alpaToday = recap.totalAbsent;
      absentEmployees = recap.absentEmployeeNames;
      todaysAttendanceList = recap.todaysAttendance; // Capture it
    } catch (e) {
      _logger.e("❌ AdminRepo Recap Error", error: e);
    }

    // 3. Keep Pending Requests specific list
    try {
      final leavesResult = await pb.collection('leave_requests').getList(
            filter: 'status = "pending"',
            perPage: 1,
          );
      pendingLeaves = leavesResult.totalItems;
    } catch (e) {
      _logger.e("Dashboard Error", error: e);
    }

    // Use local variable for safe return
    // We need to fetch recap first to get todaysAttendance
    // Since we already fetched it in step 2, we just retun it.

    // Wait, step 2 logic is inside try-catch. We need to declare attendance list outside.

    return {
      'totalEmployees': totalEmployees,
      'presentToday': presentToday,
      'leaveToday': leaveToday,
      'pendingLeaves': pendingLeaves,
      'pendingOvertime': pendingOvertime,
      'alpaToday': alpaToday,
      'absentEmployees': absentEmployees,
      'todaysAttendance': todaysAttendanceList, // Correct usage
    };
  }
}
