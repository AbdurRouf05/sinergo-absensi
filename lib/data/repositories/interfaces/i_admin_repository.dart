import 'package:attendance_fusion/data/models/dto/admin_recap_dto.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';

abstract class IAdminRepository {
  Future<AdminRecapDTO> getDailyRecap();

  Future<void> broadcastAnnouncement(
      {required String title, required String message, String target = 'all'});

  Future<void> updateEmployeeAllowedOffices(
      String userId, List<String> officeIds);

  Future<Map<String, dynamic>> fetchRawDataLocal(DateTime start, DateTime end);

  Future<List<UserLocal>> getAllEmployees();

  Future<List<LeaveRequestLocal>> getLeaveRequestsByStatus(String status);

  Future<List<AttendanceLocal>> getAttendancesByStatus(String status);

  Future<void> updateLeaveStatus(String id, String status,
      {String? rejectionReason});

  Future<void> updateAttendanceStatus(String id, String status,
      {Map<String, dynamic>? extraBody});
}
