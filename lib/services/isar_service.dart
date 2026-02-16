import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/data/models/sync_queue_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/models/daily_recap_model.dart';
import 'package:sinergo_app/data/models/notification_model.dart';

import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/data/repositories/local/user_local_repository.dart';
import 'package:sinergo_app/data/repositories/local/attendance_local_repository.dart';
import 'package:sinergo_app/data/repositories/local/office_local_repository.dart';
import 'package:sinergo_app/data/repositories/local/hr_local_repository.dart';
import 'package:sinergo_app/data/repositories/local/sync_queue_repository.dart';
import 'package:sinergo_app/data/repositories/local/notification_local_repository.dart';

import 'package:sinergo_app/services/interfaces/i_isar_service.dart';

export 'package:sinergo_app/services/interfaces/i_isar_service.dart';

/// IsarService - Core DB Provider & Facade
class IsarService extends GetxService implements IIsarService {
  final Logger _logger = Logger();

  late Isar _isar;
  bool _isInitialized = false;

  // Repositories
  late UserLocalRepository userRepo;
  late AttendanceLocalRepository attendanceRepo;
  late OfficeLocalRepository officeRepo;
  late ShiftLocalRepository shiftRepo;
  late LeaveLocalRepository leaveRepo;
  late SyncQueueRepository syncRepo;
  late NotificationLocalRepository notificationRepo;

  @override
  Isar get isar {
    if (!_isInitialized) throw const DatabaseException('Isar not initialized');
    return _isar;
  }

  @override
  Future<IsarService> init() async {
    if (_isInitialized) return this;
    _logger.i('IsarService initializing...');
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          UserLocalSchema,
          AttendanceLocalSchema,
          OfficeLocationLocalSchema,
          SyncQueueItemSchema,
          ShiftLocalSchema,
          LeaveRequestLocalSchema,
          DailyRecapLocalSchema,
          NotificationLocalSchema,
        ],
        directory: dir.path,
        name: 'sinergo_app',
        inspector: false,
      );

      _isInitialized = true;
      _initRepositories();
      _logger.i('Isar initialized at ${dir.path}');
      return this;
    } catch (e) {
      _logger.e('Failed to init Isar', error: e);
      throw DatabaseException('Failed to init database', originalError: e);
    }
  }

  void _initRepositories() {
    userRepo = UserLocalRepository(this);
    attendanceRepo = AttendanceLocalRepository(this);
    officeRepo = OfficeLocalRepository(this);
    shiftRepo = ShiftLocalRepository(this);
    leaveRepo = LeaveLocalRepository(this);
    syncRepo = SyncQueueRepository(this);
    notificationRepo = NotificationLocalRepository(this);
  }

  // --- FACADE METHODS (Delegates) ---

  // User
  @override
  Future<int> saveUser(UserLocal user) => userRepo.saveUser(user);
  @override
  Future<void> saveUsers(List<UserLocal> users) => userRepo.saveUsers(users);
  @override
  Future<UserLocal?> getCurrentUser() => userRepo.getCurrentUser();
  @override
  Future<UserLocal?> getUserByOdId(String id) => userRepo.getUserByOdId(id);
  @override
  Future<UserLocal?> getUserByEmail(String p) => userRepo.getUserByEmail(p);
  @override
  Future<void> clearUsers() => userRepo.clearUsers();

  // Attendance
  @override
  Future<int> saveAttendance(AttendanceLocal a) =>
      attendanceRepo.saveAttendance(a);
  @override
  Future<AttendanceLocal?> getAttendanceById(int id) =>
      attendanceRepo.getAttendanceById(id);
  @override
  Future<AttendanceLocal?> getAttendanceByOdId(String id) =>
      attendanceRepo.getAttendanceByOdId(id);
  @override
  Future<AttendanceLocal?> getTodayAttendance(String uid) =>
      attendanceRepo.getTodayAttendance(uid);
  @override
  Future<List<AttendanceLocal>> getAttendanceHistory(String uid,
          {DateTime? startDate,
          DateTime? endDate,
          int? limit,
          int offset = 0}) =>
      attendanceRepo.getAttendanceHistory(uid,
          startDate: startDate, endDate: endDate, limit: limit, offset: offset);
  @override
  Future<List<AttendanceLocal>> getUnsyncedAttendance() =>
      attendanceRepo.getUnsyncedAttendance();
  @override
  Future<void> markAttendanceSynced(int id, String sid) =>
      attendanceRepo.markAttendanceSynced(id, sid);
  @override
  Future<void> updateCheckout(int id, DateTime time, String? path) =>
      attendanceRepo.updateCheckout(id, time, path);

  // Office
  @override
  Future<int> saveOfficeLocation(OfficeLocationLocal l) =>
      officeRepo.saveOfficeLocation(l);
  @override
  Future<List<OfficeLocationLocal>> getActiveOfficeLocations() =>
      officeRepo.getActiveOfficeLocations();
  @override
  Stream<List<OfficeLocationLocal>> watchActiveOfficeLocations() =>
      officeRepo.watchActiveOfficeLocations();
  @override
  Future<void> saveOfficeLocations(List<OfficeLocationLocal> l) =>
      officeRepo.saveOfficeLocations(l);
  @override
  Future<OfficeLocationLocal?> getOfficeLocationByOdId(String id) =>
      officeRepo.getOfficeLocationByOdId(id);

  // HR
  @override
  Future<int> saveShift(ShiftLocal s) => shiftRepo.saveShift(s);
  @override
  Future<ShiftLocal?> getShiftById(int id) => shiftRepo.getShiftById(id);
  @override
  Future<ShiftLocal?> getShiftByOdId(String odId) =>
      shiftRepo.getShiftByOdId(odId);
  @override
  Future<void> saveShifts(List<ShiftLocal> shifts) async {
    await isar.writeTxn(() async {
      await isar.shiftLocals.putAll(shifts);
    });
  }

  @override
  Future<List<ShiftLocal>> getAllShifts() => shiftRepo.getAllShifts();

  @override
  Future<int> saveLeaveRequest(LeaveRequestLocal r) =>
      leaveRepo.saveLeaveRequest(r);
  @override
  Future<List<LeaveRequestLocal>> getLeaveRequests(String uid) =>
      leaveRepo.getLeaveRequests(uid);

  // Sync
  @override
  Future<int> addToSyncQueue(SyncQueueItem i) => syncRepo.addToSyncQueue(i);
  @override
  Future<List<SyncQueueItem>> getPendingSyncItems({int? limit}) =>
      syncRepo.getPendingSyncItems(limit: limit);
  @override
  Future<void> updateSyncQueueItem(SyncQueueItem i) =>
      syncRepo.updateSyncQueueItem(i);
  @override
  Future<int> cleanupSyncQueue(Duration d) => syncRepo.cleanupSyncQueue(d);
  @override
  Future<Map<SyncStatus, int>> getSyncQueueStats() =>
      syncRepo.getSyncQueueStats();

  // Notifications
  @override
  Future<int> saveNotification(NotificationLocal n) =>
      notificationRepo.saveNotification(n);
  @override
  Future<void> saveNotifications(List<NotificationLocal> n) =>
      notificationRepo.saveNotifications(n);
  @override
  Future<List<NotificationLocal>> getNotifications({int? limit}) =>
      notificationRepo.getNotifications(limit: limit);
  @override
  Future<NotificationLocal?> getNotificationByOdId(String id) =>
      notificationRepo.getNotificationByOdId(id);
  @override
  Future<void> markNotificationAsRead(int id) =>
      notificationRepo.markNotificationAsRead(id);
  @override
  Future<int> getUnreadNotificationCount() => notificationRepo.getUnreadCount();

  @override
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.userLocals.clear();
      await _isar.attendanceLocals.clear();
      await _isar.syncQueueItems.clear();
      await _isar.notificationLocals.clear();
    });
  }

  @override
  Future<void> close() async {
    if (_isInitialized) {
      await _isar.close();
      _isInitialized = false;
    }
  }
}
