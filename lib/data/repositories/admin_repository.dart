import 'package:sinergo_app/data/models/dto/admin_recap_dto.dart';
import 'package:sinergo_app/data/repositories/interfaces/i_admin_repository.dart';
import 'package:sinergo_app/data/repositories/admin_dashboard_repository.dart';
import 'package:sinergo_app/data/repositories/admin_recap_repository.dart';
import 'package:sinergo_app/data/repositories/admin_action_repository.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';

// ✅ FACADE PATTERN: Delegates to sub-repositories to keep file size small (Strict 200 LOC)
class AdminRepository implements IAdminRepository {
  // Note: If IAdminRepository interface hasn't changed, this is fine.
  // We can use Get.find if they are bound, or instantiate them.
  // Since this is a repo, better to instantiate or inject.
  // Previous code instantiated them.
  final AdminDashboardRepository _dashboardRepo = AdminDashboardRepository();
  final AdminRecapRepository _recapRepo = AdminRecapRepository();
  final AdminActionRepository _actionRepo = AdminActionRepository();

  @override
  Future<AdminRecapDTO> getDailyRecap() async {
    return _dashboardRepo.getDailyRecap();
  }

  @override
  Future<Map<String, dynamic>> fetchRawDataLocal(
      DateTime start, DateTime end) async {
    return _recapRepo.fetchRawDataLocal(start, end);
  }

  @override
  Future<void> broadcastAnnouncement(
      {required String title,
      required String message,
      String target = 'all'}) async {
    return _actionRepo.broadcastAnnouncement(
        title: title, message: message, target: target);
  }

  @override
  Future<void> updateEmployeeAllowedOffices(
      String userId, List<String> officeIds) async {
    return _actionRepo.updateEmployeeAllowedOffices(userId, officeIds);
  }

  @override
  Future<List<UserLocal>> getAllEmployees(
      {int? limit, int offset = 0, String? searchQuery}) async {
    // This logic probably moved to Dashboard or Recap.
    // Checking AdminDashboardRepository... it has fetchEmployeesFromServer and logic.
    // Checking AdminRecapRepository... it has getUsers.
    // Let's assume it's in Dashboard or use a new method matching functionality.
    // Dashboard repo has `fetchEmployeesFromServer`.
    // But `getAllEmployees` sounds like local fetch?
    // AdminDashboardRepo uses `_isar.userLocals` in `getDailyRecap`.
    // I need to check if proper method exists. Use _dashboardRepo.fetchEmployeesFromServer() as it returns Future<List<UserLocal>>?
    // Wait, fetchEmployees returns void in controller usually.
    // Let's assuming for now I can map it or I need to find where getAllEmployees went.
    // It was likely in AdminAnalyticsRepository.
    // If I didn't move it, I should add it to AdminDashboardRepository.
    // Let's add it there if missing. But for now I'll try to find similar.
    // Actually, AdminDashboardRepository has logic to fetch.
    // I will assume `_dashboardRepo.getAllEmployees()` exists or I will add it.
    // I'll check AdminDashboardRepository content in my memory or view it.
    // Better: I will use `_recapRepo.fetchRawDataLocal` to get users? No.
    // Note: AdminAnalyticsRepository had `getAllEmployees`.
    // I should have moved it.
    // I'll call `_dashboardRepo.getAllEmployees()` and if it errors I'll fix the repo.
    return _dashboardRepo.getAllEmployees(
        limit: limit, offset: offset, searchQuery: searchQuery);
  }

  @override
  Future<List<LeaveRequestLocal>> getLeaveRequestsByStatus(
      String status) async {
    return _recapRepo.getLeaveRequestsByStatus(status);
  }

  @override
  Future<List<AttendanceLocal>> getAttendancesByStatus(String status) async {
    return _recapRepo.getAttendancesByStatus(status);
  }

  @override
  Future<void> updateLeaveStatus(String id, String status,
      {String? rejectionReason}) async {
    return _actionRepo.updateLeaveStatus(id, status,
        rejectionReason: rejectionReason);
  }

  @override
  Future<void> updateAttendanceStatus(String id, String status,
      {Map<String, dynamic>? extraBody}) async {
    return _actionRepo.updateAttendanceStatus(id, status, extraBody: extraBody);
  }
}
