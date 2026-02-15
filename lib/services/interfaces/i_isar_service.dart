import 'package:isar/isar.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/data/models/sync_queue_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/notification_model.dart';
import 'package:attendance_fusion/data/models/dynamic_outpost_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

/// Interface for IsarService to enable clean mocking in tests
abstract class IIsarService {
  Isar get isar;
  Future<IsarService> init();

  // User
  Future<int> saveUser(UserLocal user);
  Future<void> saveUsers(List<UserLocal> users);
  Future<UserLocal?> getCurrentUser();
  Future<UserLocal?> getUserByOdId(String id);
  Future<UserLocal?> getUserByEmail(String p);
  Future<void> clearUsers();

  // Attendance
  Future<int> saveAttendance(AttendanceLocal a);
  Future<AttendanceLocal?> getAttendanceById(int id);
  Future<AttendanceLocal?> getAttendanceByOdId(String id);
  Future<AttendanceLocal?> getTodayAttendance(String uid);
  Future<List<AttendanceLocal>> getAttendanceHistory(String uid,
      {DateTime? startDate, DateTime? endDate, int? limit});
  Future<List<AttendanceLocal>> getUnsyncedAttendance();
  Future<void> markAttendanceSynced(int id, String sid);
  Future<void> updateCheckout(int id, DateTime time, String? path);

  // Office
  Future<int> saveOfficeLocation(OfficeLocationLocal l);
  Future<List<OfficeLocationLocal>> getActiveOfficeLocations();
  Stream<List<OfficeLocationLocal>> watchActiveOfficeLocations();
  Future<void> saveOfficeLocations(List<OfficeLocationLocal> l);
  Future<OfficeLocationLocal?> getOfficeLocationByOdId(String id);

  // Dynamic Outpost
  Future<int> saveDynamicOutpost(DynamicOutpostLocal outpost);
  Future<List<DynamicOutpostLocal>> getActiveDynamicOutposts();
  Future<void> cleanExpiredOutposts();
  Future<void> deactivateOutpost(int id);

  // HR
  Future<int> saveShift(ShiftLocal s);
  Future<ShiftLocal?> getShiftById(int id);
  Future<ShiftLocal?> getShiftByOdId(String odId);
  Future<void> saveShifts(List<ShiftLocal> shifts);
  Future<List<ShiftLocal>> getAllShifts();
  Future<int> saveLeaveRequest(LeaveRequestLocal r);
  Future<List<LeaveRequestLocal>> getLeaveRequests(String uid);

  // Sync
  Future<int> addToSyncQueue(SyncQueueItem i);
  Future<List<SyncQueueItem>> getPendingSyncItems({int? limit});
  Future<void> updateSyncQueueItem(SyncQueueItem i);
  Future<int> cleanupSyncQueue(Duration d);
  // Notifications
  Future<int> saveNotification(NotificationLocal n);
  Future<void> saveNotifications(List<NotificationLocal> n);
  Future<List<NotificationLocal>> getNotifications({int? limit});
  Future<NotificationLocal?> getNotificationByOdId(String id);
  Future<void> markNotificationAsRead(int id);
  Future<int> getUnreadNotificationCount();

  Future<Map<SyncStatus, int>> getSyncQueueStats();

  Future<void> clearAllData();
  Future<void> close();
}
