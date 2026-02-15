import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:attendance_fusion/modules/attendance/checkout/checkout_controller.dart';
import 'package:attendance_fusion/services/device_service.dart';
import 'package:attendance_fusion/services/location_service.dart';
import 'package:attendance_fusion/services/wifi_service.dart';
import 'package:attendance_fusion/services/time_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/data/repositories/attendance_repository.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/dynamic_outpost_model.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/notification_model.dart';
import 'package:attendance_fusion/data/models/sync_queue_model.dart';
import 'package:isar/isar.dart';
import 'package:attendance_fusion/core/errors/app_exceptions.dart';
import 'package:attendance_fusion/modules/attendance/checkin/logic/checkin_dialog_helper.dart'; // Added for test mode

// --- PURE DART MOCKS ---
class PureMockDeviceService implements IDeviceService {
  @override
  RxBool isDeviceCompromised = false.obs;
  @override
  RxBool isDeviceBound = false.obs;
  String mockDeviceId = 'device_123';
  @override
  Future<String> getDeviceId() async => mockDeviceId;
  @override
  Future<Map<String, dynamic>> getDeviceFingerprint() async => {};
  @override
  Future<bool> validateDeviceBinding(String? registeredDeviceId) async => true;
  @override
  Future<bool> isNewDevice(String? registeredDeviceId) async => false;
}

class PureMockLocationService implements ILocationService {
  @override
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  @override
  final RxBool isMockLocationDetected = false.obs;

  Future<Position?> Function({bool forceRefresh})? getCurrentPositionStub;
  double mockDistance = 0.0;

  @override
  Future<Position?> getCurrentPosition({bool forceRefresh = false}) async =>
      getCurrentPositionStub?.call(forceRefresh: forceRefresh);

  @override
  double calculateDistance(
          double lat1, double lng1, double lat2, double lng2) =>
      mockDistance;

  @override
  bool isWithinRadius(double lat, double lng, double targetLat,
          double targetLng, double radius) =>
      true;

  @override
  void startLocationUpdates({required Function(Position) onUpdate}) {}
  @override
  void stopLocationUpdates() {}

  @override
  Future<bool> detectMockLocation(Position position) async => false;
}

class PureMockWifiService implements IWifiService {
  @override
  RxString currentBssid = ''.obs;
  @override
  RxString currentSsid = ''.obs;
  @override
  RxBool isConnectedToWifi = false.obs;
  @override
  RxBool isOfficeWifi = false.obs;
  bool mockIsConnected = false;
  @override
  Future<void> refreshWifiInfo() async {}
  @override
  Future<String?> getFormattedBssid() async => 'AA:BB:CC';
  @override
  Future<bool> isConnectedToOfficeWifi(List<String> bssids) async =>
      mockIsConnected;
}

class PureMockTimeService implements ITimeService {
  TrustedTimeResult? mockResult;
  @override
  Future<TrustedTimeResult> getTrustedTime() async =>
      mockResult ??
      TrustedTimeResult(
        time: DateTime.now(),
        source: TimeSource.ntp,
        isManipulated: false,
        deviationSeconds: 0,
      );
  @override
  Future<bool> detectTimeManipulation() async => false;
}

class PureMockIsarService implements IIsarService {
  List<OfficeLocationLocal> mockOffices = [];
  AttendanceLocal? mockTodayAttendance;
  bool updateCheckoutCalled = false;

  @override
  Isar get isar => throw UnimplementedError();

  @override
  Future<IsarService> init() async => throw UnimplementedError();

  @override
  Future<int> saveUser(UserLocal user) async => 1;
  @override
  Future<void> saveUsers(List<UserLocal> users) async {}

  @override
  Future<int> saveNotification(NotificationLocal n) async => 0;
  @override
  Future<void> saveNotifications(List<NotificationLocal> n) async {}
  @override
  Future<List<NotificationLocal>> getNotifications({int? limit}) async => [];
  @override
  Future<NotificationLocal?> getNotificationByOdId(String id) async => null;
  @override
  Future<void> markNotificationAsRead(int id) async {}
  @override
  Future<int> getUnreadNotificationCount() async => 0;

  @override
  Future<UserLocal?> getCurrentUser() async => null;
  @override
  Future<UserLocal?> getUserByOdId(String id) async => null;
  @override
  Future<UserLocal?> getUserByEmail(String p) async => null;
  @override
  Future<void> clearUsers() async {}

  @override
  Future<int> saveAttendance(AttendanceLocal a) async => 1;
  @override
  Future<AttendanceLocal?> getAttendanceById(int id) async =>
      mockTodayAttendance;
  @override
  Future<AttendanceLocal?> getAttendanceByOdId(String id) async => null;
  @override
  Future<AttendanceLocal?> getTodayAttendance(String uid) async =>
      mockTodayAttendance;
  @override
  Future<List<AttendanceLocal>> getAttendanceHistory(String uid,
          {DateTime? startDate, DateTime? endDate, int? limit}) async =>
      [];
  @override
  Future<List<AttendanceLocal>> getUnsyncedAttendance() async => [];
  @override
  Future<void> markAttendanceSynced(int id, String sid) async {}

  @override
  Future<void> updateCheckout(int id, DateTime time, String? path) async {
    updateCheckoutCalled = true;
    mockTodayAttendance?.checkOutTime = time;
  }

  @override
  Future<int> saveOfficeLocation(OfficeLocationLocal l) async => 1;
  @override
  Future<List<OfficeLocationLocal>> getActiveOfficeLocations() async =>
      mockOffices;
  @override
  Stream<List<OfficeLocationLocal>> watchActiveOfficeLocations() =>
      Stream.value(mockOffices);
  @override
  Future<void> saveOfficeLocations(List<OfficeLocationLocal> l) async {}
  @override
  Future<OfficeLocationLocal?> getOfficeLocationByOdId(String id) async => null;

  @override
  Future<int> saveShift(ShiftLocal s) async => 1;
  @override
  Future<ShiftLocal?> getShiftById(int id) async => null;
  @override
  Future<ShiftLocal?> getShiftByOdId(String odId) async => null;

  @override
  Future<void> saveShifts(List<ShiftLocal> shifts) async {}

  @override
  Future<List<ShiftLocal>> getAllShifts() async => [];

  @override
  Future<int> saveLeaveRequest(LeaveRequestLocal r) async => 1;
  @override
  Future<List<LeaveRequestLocal>> getLeaveRequests(String uid) async => [];

  @override
  Future<int> addToSyncQueue(SyncQueueItem i) async => 1;
  @override
  Future<List<SyncQueueItem>> getPendingSyncItems({int? limit}) async => [];
  @override
  Future<void> updateSyncQueueItem(SyncQueueItem i) async {}
  @override
  Future<int> cleanupSyncQueue(Duration d) async => 0;
  @override
  Future<Map<SyncStatus, int>> getSyncQueueStats() async => {};

  @override
  Future<int> saveDynamicOutpost(DynamicOutpostLocal outpost) async => 1;
  @override
  Future<List<DynamicOutpostLocal>> getActiveDynamicOutposts() async => [];
  @override
  Future<void> cleanExpiredOutposts() async {}
  @override
  Future<void> deactivateOutpost(int id) async {}

  @override
  Future<void> clearAllData() async {}
  @override
  Future<void> close() async {}
}

class PureMockAuthService implements IAuthService {
  @override
  Rx<UserLocal?> currentUser = Rx<UserLocal?>(null);
  @override
  RxBool isAuthenticated = true.obs;
  @override
  RxBool isLoading = false.obs;
  @override
  Future<AuthService> init() async => throw UnimplementedError();
  @override
  Future<UserLocal> login(String email, String password) async =>
      throw UnimplementedError();
  @override
  Future<void> logout() async {}
  @override
  bool get isHROrAdmin => false;
  @override
  bool get isAdmin => false;
  @override
  PocketBase get pb => throw UnimplementedError();
  @override
  Future<void> restoreSession() async {}
  @override
  Future<UserLocal> debugLogin() async => throw UnimplementedError();
}

class PureMockAttendanceRepository implements IAttendanceRepository {
  int saveCount = 0;
  AttendanceLocal? lastSaved;
  bool shouldSyncFail = false;
  int syncCount = 0;
  AttendanceLocal? mockTodayAttendance;

  @override
  Future<int> saveAttendanceOffline(AttendanceLocal attendance) async {
    saveCount++;
    lastSaved = attendance;
    return 1;
  }

  @override
  Future<void> syncToCloud(int localId) async {
    syncCount++;
    if (shouldSyncFail) throw const NetworkException('Fail');
  }

  @override
  Future<AttendanceLocal?> getTodayAttendance() async => mockTodayAttendance;

  @override
  Future<void> updateAttendance(AttendanceLocal attendance) async {}
}

void main() {
  late CheckoutController controller;
  late PureMockDeviceService mockDevice;
  late PureMockLocationService mockLocation;
  late PureMockWifiService mockWifi;
  late PureMockTimeService mockTime;
  late PureMockIsarService mockIsar;
  late PureMockAuthService mockAuth;
  late PureMockAttendanceRepository mockRepo;

  Position createPos(double lat, double lng, {bool isMocked = false}) {
    return Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      isMocked: isMocked,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  setUp(() async {
    Get.testMode = true;
    Isar.initializeIsarCore(download: true);
    Get.reset();
    final envFile = File('.env.test');
    envFile.writeAsStringSync('DEV_MODE=false\nBASE_URL=http://localhost:8090');
    await dotenv.load(fileName: '.env.test');
    CheckinDialogHelper.isTestMode = true; // Manual override

    mockDevice = PureMockDeviceService();
    mockLocation = PureMockLocationService();
    mockWifi = PureMockWifiService();
    mockTime = PureMockTimeService();
    mockIsar = PureMockIsarService();
    mockAuth = PureMockAuthService();
    mockRepo = PureMockAttendanceRepository();

    // Mock today's attendance (already checked in)
    final todayAttendance = AttendanceLocal()
      ..id = 1
      ..userId = 'u1'
      ..checkInTime = DateTime.now().subtract(const Duration(hours: 4))
      ..isWifiVerified = true
      ..deviceIdUsed = 'device_123'
      ..status = AttendanceStatus.present
      ..isSynced = false;

    mockIsar.mockTodayAttendance = todayAttendance;
    mockRepo.mockTodayAttendance = todayAttendance;

    controller = CheckoutController(
      deviceService: mockDevice,
      locationService: mockLocation,
      wifiService: mockWifi,
      timeService: mockTime,
      isarService: mockIsar,
      attendanceRepository: mockRepo,
    );

    // Manually set todayAttendance since onInit is async
    controller.onInit();
    controller.todayAttendance.value = mockRepo.mockTodayAttendance;
    controller.skipValidation.value = true; // Default to dev mode

    // Default behavior
    mockLocation.getCurrentPositionStub =
        ({bool? forceRefresh}) async => createPos(-6.2000, 106.8166);
    mockAuth.currentUser.value = UserLocal()..odId = 'u1';
  });

  group('Checkout Controller Tests', () {
    test('Should detect when no check-in exists', () async {
      mockRepo.mockTodayAttendance = null;

      // Recreate controller with no attendance
      final noCheckInController = CheckoutController(
        deviceService: mockDevice,
        locationService: mockLocation,
        wifiService: mockWifi,
        timeService: mockTime,
        isarService: mockIsar,
        attendanceRepository: mockRepo,
      );

      await noCheckInController.validateAndSubmit();

      expect(mockIsar.updateCheckoutCalled, false);
    });

    test('Should prevent double checkout', () async {
      // Set already checked out
      mockRepo.mockTodayAttendance!.checkOutTime = DateTime.now();

      await controller.validateAndSubmit();

      expect(mockIsar.updateCheckoutCalled, false);
    });

    test('Should block on mock location', () async {
      // Disable dev mode skip
      controller.skipValidation.value = false;

      mockLocation.getCurrentPositionStub = ({bool? forceRefresh}) async =>
          createPos(-6.2, 106.8, isMocked: true);

      await controller.validateAndSubmit();

      expect(mockIsar.updateCheckoutCalled, false);
    });

    test('Should block on time manipulation', () async {
      mockTime.mockResult = TrustedTimeResult(
        time: DateTime.now(),
        source: TimeSource.ntp,
        isManipulated: true,
        deviationSeconds: 500,
      );

      await controller.validateAndSubmit();

      expect(mockIsar.updateCheckoutCalled, false);
    });

    test('Success checkout - Dev mode skips GPS validation', () async {
      controller.skipValidation.value = true;

      await controller.validateAndSubmit();

      expect(mockIsar.updateCheckoutCalled, true);
      expect(mockRepo.syncCount, 1);
    });

    test('Optional photo capture allowed', () async {
      controller.skipValidation.value = true;

      // No photo captured - should still work
      expect(controller.cameraManager.capturedPhoto.value, isNull);

      await controller.validateAndSubmit();

      expect(mockIsar.updateCheckoutCalled, true);
    });
  });
}
