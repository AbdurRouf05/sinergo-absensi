import 'package:get/get.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/modules/attendance/attendance_controller.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/location_service.dart';
import 'package:attendance_fusion/services/permission_service.dart';
import 'package:attendance_fusion/services/time_service.dart';
import 'package:attendance_fusion/services/wifi_service.dart';

import '../history/history_controller.dart';
import 'logic/home_data_manager.dart';
import 'logic/home_diagnostics_manager.dart';
import 'logic/home_sync_manager.dart';

/// HomeController - Main dashboard controller
class HomeController extends GetxController {
  // Services
  final IAuthService _authService = Get.find<IAuthService>();
  final IPermissionService _permissionService = Get.find<IPermissionService>();
  final IWifiService _wifiService = Get.find<IWifiService>();
  final ILocationService _locationService = Get.find<ILocationService>();
  final ITimeService _timeService = Get.find<ITimeService>();
  final IIsarService _isarService = Get.find<IIsarService>();

  // Managers (Logic Split)
  late final HomeDiagnosticsManager diagnosticsManager;
  late final HomeDataManager dataManager;
  late final HomeSyncManager syncManager;

  // External Controllers
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  final HistoryController historyController = Get.put(HistoryController());

  // User data
  UserLocal? get currentUser => _authService.currentUser.value;
  Rx<UserLocal?> get user => _authService.currentUser;

  // Observable states
  final RxInt currentTabIndex = 0.obs;
  final RxString greeting = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize Managers
    diagnosticsManager =
        HomeDiagnosticsManager(_wifiService, _locationService, _timeService);
    dataManager = HomeDataManager(_authService, _isarService);
    syncManager = HomeSyncManager(_authService, _isarService);

    _updateGreeting();
    // Attendance logic handled by AttendanceController, but we listen to it
    // Actually our SyncManager now handles UI rendering for Dashboard specific cards?
    // Or we keep listening to AttendanceController?
    // The original code listened to AttendanceController.
    // Let's rely on SyncManager for the Dashboard card data as it is customized there.
    // BUT, we also want to trigger SyncManager when AttendanceController updates.

    // Initial Load
    diagnosticsManager.loadDiagnostics();
    dataManager.loadShift();
    syncManager.checkTodayAttendance();
  }

  // Proxies for UI
  RxString get currentShiftName => dataManager.currentShiftName;
  RxString get checkInTimeStr => syncManager.checkInTimeStr;
  RxString get checkOutTimeStr => syncManager.checkOutTimeStr;
  RxString get attendanceStatusStr => syncManager.attendanceStatusStr;
  RxBool get hasCheckedInToday => syncManager.hasCheckedInToday;

  // Diagnostics Proxies
  RxString get wifiInfo => diagnosticsManager.wifiInfo;
  RxString get locationInfo => diagnosticsManager.locationInfo;
  RxString get timeStatus => diagnosticsManager.timeStatus;

  Future<void> refreshDashboard() async {
    await syncManager.checkTodayAttendance();
    await dataManager.loadShift();
    await diagnosticsManager.loadDiagnostics();
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> _updateGreeting() async {
    final result = await _timeService.getTrustedTime();
    final hour = result.time.hour;

    if (hour >= 4 && hour < 10) {
      greeting.value = 'Selamat Pagi ☀️';
    } else if (hour >= 10 && hour < 14) {
      greeting.value = 'Selamat Siang 🌤️';
    } else if (hour >= 14 && hour < 18) {
      greeting.value = 'Selamat Sore 🌥️';
    } else {
      greeting.value = 'Selamat Malam 🌙';
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  bool get hasAllPermissions => _permissionService.hasAllRequiredPermissions;

  Future<void> requestPermissions() async {
    await _permissionService.requestAllAttendancePermissions();
    diagnosticsManager.loadDiagnostics();
  }
}
