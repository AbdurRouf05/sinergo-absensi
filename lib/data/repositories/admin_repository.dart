import 'package:attendance_fusion/data/models/dto/admin_recap_dto.dart';
import 'package:attendance_fusion/data/repositories/interfaces/i_admin_repository.dart';
import 'package:attendance_fusion/data/repositories/admin_analytics_repository.dart';
import 'package:attendance_fusion/data/repositories/admin_action_repository.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';

// ✅ FACADE PATTERN: Delegates to sub-repositories to keep file size small (Strict 200 LOC)
class AdminRepository implements IAdminRepository {
  final AdminAnalyticsRepository _analyticsRepo = AdminAnalyticsRepository();
  final AdminActionRepository _actionRepo = AdminActionRepository();

  @override
  Future<AdminRecapDTO> getDailyRecap() async {
    return _analyticsRepo.getDailyRecap();
  }

  @override
  Future<Map<String, dynamic>> fetchRawDataLocal(
      DateTime start, DateTime end) async {
    return _analyticsRepo.fetchRawDataLocal(start, end);
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
  Future<List<UserLocal>> getAllEmployees() async {
    return _analyticsRepo.getAllEmployees();
  }

  @override
  Future<List<LeaveRequestLocal>> getLeaveRequestsByStatus(
      String status) async {
    return _analyticsRepo.getLeaveRequestsByStatus(status);
  }

  @override
  Future<List<AttendanceLocal>> getAttendancesByStatus(String status) async {
    return _analyticsRepo.getAttendancesByStatus(status);
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
