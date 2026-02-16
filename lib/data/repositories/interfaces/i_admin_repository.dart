import 'package:sinergo_app/data/models/dto/admin_recap_dto.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';

abstract class IAdminRepository {
  Future<AdminRecapDTO> getDailyRecap();

  Future<void> broadcastAnnouncement(
      {required String title, required String message, String target = 'all'});

  Future<void> updateEmployeeAllowedOffices(
      String userId, List<String> officeIds);

  Future<Map<String, dynamic>> fetchRawDataLocal(DateTime start, DateTime end);

  Future<List<UserLocal>> getAllEmployees(
      {int? limit, int offset = 0, String? searchQuery});

  Future<List<LeaveRequestLocal>> getLeaveRequestsByStatus(String status);

  Future<List<AttendanceLocal>> getAttendancesByStatus(String status);

  Future<void> updateLeaveStatus(String id, String status,
      {String? rejectionReason});

  Future<void> updateAttendanceStatus(String id, String status,
      {Map<String, dynamic>? extraBody});
}
