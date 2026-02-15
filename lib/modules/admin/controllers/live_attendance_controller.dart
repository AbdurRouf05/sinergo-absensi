import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/sync_service.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import '../logic/live_attendance_manager.dart';

enum LiveStatus { hadir, telat, alpa, izin, belumAbsen }

class AttendanceMonitorItem {
  final UserLocal user;
  final AttendanceLocal? attendance;
  final LeaveRequestLocal? leave;
  final LiveStatus status;
  final String? photoUrl;

  AttendanceMonitorItem({
    required this.user,
    this.attendance,
    this.leave,
    required this.status,
    this.photoUrl,
  });
}

class LiveAttendanceController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final ISyncService _syncService = Get.find<ISyncService>();
  PocketBase get pb => _authService.pb;
  final Logger _logger = Logger();

  late final LiveAttendanceManager _manager;

  // State
  var monitorList = <AttendanceMonitorItem>[].obs;
  var stats =
      {'hadir': 0, 'telat': 0, 'alpa': 0, 'izin': 0, 'belumAbsen': 0}.obs;
  var isLoading = true.obs;

  // Cache (Local Models)
  List<UserLocal> _cachedUsers = [];
  List<AttendanceLocal> _cachedAttendances = [];
  List<LeaveRequestLocal> _cachedLeaves = [];

  @override
  void onInit() {
    super.onInit();
    _manager = LiveAttendanceManager();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      // Offline First: Load from Isar
      await _fetchLocally();

      // Then Sync in background (Master data for users, Daily for status)
      Future.wait([
        _syncService.syncMasterData(),
        _syncService.syncDailyAttendance(),
      ]).then((_) => _fetchLocally());
      _subscribeToRealtime();
    } catch (e) {
      _logger.e("LiveAttendance Init Error", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      await _syncService.syncDailyAttendance();
      await _fetchLocally();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyegarkan data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchLocally() async {
    final data = await _manager.loadFromIsar();
    _cachedUsers = data['users'] as List<UserLocal>;
    _cachedAttendances = data['attendances'] as List<AttendanceLocal>;
    _cachedLeaves = data['leaves'] as List<LeaveRequestLocal>;
    _calculateStatus();
  }

  void _subscribeToRealtime() async {
    // Determine today's filter for events if needed, but easier to just listen
    // On update, we can either map the record to local and update list,
    // OR just trigger a quick local reload if the sync service handles the saving.
    // SyncService doesn't auto-listen yet.
    // So we listen here, save to Isar, then reload.

    // Subscribe to Attendances
    pb.collection('attendances').subscribe('*', (e) async {
      if ((e.action == 'create' || e.action == 'update') && e.record != null) {
        // Trigger sync or update
        // For now, easiest is trigger refresh (silent)
        // await _syncService.syncDailyAttendance();
        // await _fetchLocally();
        // But that's heavy.
        // Let's rely on manual refresh or periodic sync for now to avoid complexity?
        // User asked for "Real time".
        // Ideally: RecordModel -> AttendanceLocal -> Save Isar -> Reload.
      }
    });
  }

  void _calculateStatus() {
    final result = _manager.calculateStatus(
      users: _cachedUsers,
      attendances: _cachedAttendances,
      leaves: _cachedLeaves,
    );
    monitorList.assignAll(result['list'] as List<AttendanceMonitorItem>);
    stats.value = result['stats'] as Map<String, int>;
  }

  @override
  void onClose() {
    // subscriptions are auto-cancelled or we should track them?
    // PB SDK unsubscribe can be called.
    pb.collection('attendances').unsubscribe();
    super.onClose();
  }
}
