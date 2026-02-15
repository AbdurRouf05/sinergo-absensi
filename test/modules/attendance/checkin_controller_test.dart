import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:attendance_fusion/modules/attendance/checkin/checkin_controller.dart';
import 'package:attendance_fusion/modules/attendance/checkin/logic/checkin_dialog_helper.dart'; // Added for test mode
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
import 'package:attendance_fusion/modules/attendance/checkin/logic/checkin_status_helper.dart';
import 'package:attendance_fusion/data/models/shift_model.dart'; // NEW
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/notification_model.dart';
import 'package:attendance_fusion/data/models/sync_queue_model.dart';
import 'package:attendance_fusion/data/models/dynamic_outpost_model.dart';
import 'package:attendance_fusion/core/errors/app_exceptions.dart';
import 'package:attendance_fusion/modules/attendance/checkin/logic/office_selection_manager.dart';
import 'package:attendance_fusion/modules/attendance/checkin/logic/checkin_location_manager.dart';
import 'package:attendance_fusion/modules/attendance/checkin/logic/ganas_manager.dart';
import 'package:attendance_fusion/modules/attendance/checkin/logic/overtime_manager.dart';
import 'package:attendance_fusion/services/sync_service.dart';
import 'package:attendance_fusion/services/permission_service.dart';
import 'package:attendance_fusion/services/security_service.dart';
import 'package:permission_handler/permission_handler.dart';

typedef PureMockRepo = PureMockAttendanceRepository;

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
  Future<bool> detectMockLocation(Position position) async => position.isMocked;
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

  UserLocal? mockUser;
  @override
  Future<UserLocal?> getCurrentUser() async => mockUser;
  @override
  Future<UserLocal?> getUserByOdId(String id) async => mockUser;
  @override
  Future<UserLocal?> getUserByEmail(String p) async => null;
  @override
  Future<void> clearUsers() async {}

  @override
  Future<int> saveAttendance(AttendanceLocal a) async => 1;
  @override
  Future<AttendanceLocal?> getAttendanceById(int id) async => null;
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
  Future<void> updateCheckout(int id, DateTime time, String? path) async {}

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

  ShiftLocal? mockShift;
  AttendanceLocal? mockTodayAttendance;

  @override
  Future<int> saveShift(ShiftLocal s) async => 1;
  @override
  Future<ShiftLocal?> getShiftById(int id) async => mockShift;
  @override
  Future<ShiftLocal?> getShiftByOdId(String odId) async => mockShift;

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
  RxBool isAuthenticated = false.obs;
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

class PureMockPermissionService implements IPermissionService {
  @override
  final RxBool hasLocationPermission = true.obs;
  @override
  final RxBool hasCameraPermission = true.obs;
  @override
  final RxBool hasNotificationPermission = true.obs;
  @override
  final RxBool hasBackgroundLocationPermission = true.obs;
  @override
  bool get hasAllRequiredPermissions => true;
  @override
  Future<PermissionStatus> requestLocationPermission() async =>
      PermissionStatus.granted;
  @override
  Future<PermissionStatus> requestCameraPermission() async =>
      PermissionStatus.granted;
  @override
  Future<PermissionStatus> requestNotificationPermission() async =>
      PermissionStatus.granted;
  @override
  Future<Map<String, PermissionStatus>>
      requestAllAttendancePermissions() async => {};
  @override
  Future<bool> openSettings() async => true;
}

class PureMockSecurityService implements ISecurityService {
  @override
  Future<bool> performSecurityCheck() async => true;
}

class PureMockAttendanceRepository implements IAttendanceRepository {
  int saveCount = 0;
  AttendanceLocal? lastSaved;
  bool shouldSyncFail = false;
  int syncCount = 0;

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
  Future<AttendanceLocal?> getTodayAttendance() async => null;

  @override
  Future<void> updateAttendance(AttendanceLocal attendance) async {
    saveCount++;
    lastSaved = attendance;
  }
}

// --- NEW CRITICAL MOCKS FOR REFACTOR ---
class PureMockSelectionManager extends OfficeSelectionManager {
  @override
  void updateLocation(Position position) {}
  @override
  void selectOffice(OfficeLocationLocal office) {
    selectedOffice.value = office;
  }
}

class PureMockCheckInLocationManager extends CheckInLocationManager {
  // CRITICAL: Pass non-null to avoid Get.find fallback in base
  PureMockCheckInLocationManager(OfficeSelectionManager selection)
      : super(
          locationService: Get.find<ILocationService>(),
          selectionManager: selection,
        );

  @override
  Future<Position?> getCurrentPosition({bool forceRefresh = false}) async =>
      lastPosition;
}

void main() {
  late CheckinController controller;
  late PureMockDeviceService mockDevice;
  late PureMockLocationService mockLocation;
  late PureMockWifiService mockWifi;
  late PureMockTimeService mockTime;
  late PureMockIsarService mockIsar;
  late PureMockAuthService mockAuth;
  late PureMockRepo mockRepo;
  late PureMockPermissionService mockPermission;
  late PureMockSecurityService mockSecurity;
  late PureMockSelectionManager mockSelection;
  late PureMockCheckInLocationManager mockLocManager;
  late GanasManager ganasManager;

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
    CheckinDialogHelper.isTestMode = true; // Manual override
    Get.reset();

    mockDevice = PureMockDeviceService();
    mockLocation = PureMockLocationService();
    mockWifi = PureMockWifiService();
    mockTime = PureMockTimeService();
    mockIsar = PureMockIsarService();
    mockAuth = PureMockAuthService();
    mockRepo = PureMockAttendanceRepository();
    mockPermission = PureMockPermissionService();
    mockSecurity = PureMockSecurityService();

    mockIsar.mockOffices = [
      OfficeLocationLocal()
        ..odId = 'office_1'
        ..lat = -6.2000
        ..lng = 106.8166
        ..radius = 100.0
    ];

    // Register mocks in Get for managers/controllers to find
    Get.put<IDeviceService>(mockDevice);
    Get.put<ILocationService>(mockLocation);
    Get.put<IWifiService>(mockWifi);
    Get.put<ITimeService>(mockTime);
    Get.put<IIsarService>(mockIsar);
    Get.put<IAuthService>(mockAuth);
    Get.put<IAttendanceRepository>(mockRepo);
    Get.put<IPermissionService>(mockPermission);
    Get.put<ISecurityService>(mockSecurity);
    Get.put<ISyncService>(SyncService()); // Basic instance for test

    // INJECT MOCK MANAGERS BEFORE controller.onInit()
    mockSelection = PureMockSelectionManager();
    Get.put<OfficeSelectionManager>(mockSelection);

    mockLocManager = PureMockCheckInLocationManager(mockSelection);
    Get.put<CheckInLocationManager>(mockLocManager);

    ganasManager = Get.put(GanasManager());

    controller = CheckinController(
      deviceService: mockDevice,
      timeService: mockTime,
      isarService: mockIsar,
      syncService: Get.find<ISyncService>(),
    );

    // Default "Happy Path" behavior
    mockLocation.getCurrentPositionStub =
        ({bool? forceRefresh}) async => createPos(-6.2000, 106.8166);
    mockLocation.mockDistance = 10.0;
    mockWifi.mockIsConnected = true;
    mockAuth.currentUser.value = UserLocal()..odId = 'default_user';

    // Ensure async initialization completes
    controller.onInit();

    // SETUP HAPPY PATH DEFAULT
    mockSelection.selectedOffice.value = mockIsar.mockOffices.first;
    mockSelection.isInsideRadius.value = true;
    mockSelection.currentDistance.value = 10.0;
    mockLocManager.lastPosition = createPos(-6.2000, 106.8166);
    mockLocManager.statusMessage.value = 'Ready';
  });

  group('Guardian V2 - Pure Dart Final Verification', () {
    test('GPS Mocking Protection - Should block attendance', () async {
      mockLocation.getCurrentPositionStub = ({bool? forceRefresh}) async =>
          createPos(-6.2, 106.8, isMocked: true);

      await controller.validateAndSubmit();

      expect(mockRepo.saveCount, 0);
      expect(controller.isLoading.value, false);
    });

    test('Geofence Protection - Should block if too far', () async {
      mockLocManager.lastPosition = createPos(-6.3, 106.9);
      mockSelection.currentDistance.value = 500.0;
      mockSelection.isInsideRadius.value = false;
      mockSelection.selectedOffice.value = mockIsar.mockOffices.first;

      await controller.validateAndSubmit();

      expect(controller.isInsideRadius.value, false);
      expect(mockRepo.saveCount, 0);
    });

    test('Full Happy Path - Online Success', () async {
      final now = DateTime.now();
      mockLocManager.lastPosition = createPos(-6.2, 106.8);
      mockSelection.currentDistance.value = 10.0;
      mockSelection.isInsideRadius.value = true;
      mockSelection.selectedOffice.value = mockIsar.mockOffices.first;

      mockTime.mockResult = TrustedTimeResult(
        time: now,
        source: TimeSource.ntp,
        isManipulated: false,
        deviationSeconds: 0,
      );
      mockWifi.mockIsConnected = true;
      mockAuth.currentUser.value = UserLocal()..odId = 'u1';

      // Mock photo capture (WAJIB per ROADMAP)
      controller.cameraManager.capturedPhoto.value = File('test_photo.jpg');

      await controller.validateAndSubmit();

      expect(mockRepo.saveCount, 1);
      expect(mockRepo.syncCount, 1);
      expect(mockRepo.lastSaved?.checkInTime, now);
    });

    test('Offline Resilience - Save even if sync fails', () async {
      mockLocManager.lastPosition = createPos(-6.2, 106.8);
      mockSelection.currentDistance.value = 10.0;
      mockSelection.isInsideRadius.value = true;
      mockSelection.selectedOffice.value = mockIsar.mockOffices.first;

      mockAuth.currentUser.value = UserLocal()..odId = 'u1';
      mockRepo.shouldSyncFail = true;

      // Mock photo capture (WAJIB per ROADMAP)
      controller.cameraManager.capturedPhoto.value = File('test_photo.jpg');

      await controller.validateAndSubmit();

      expect(mockRepo.saveCount, 1);
      expect(controller.isLoading.value, false);
    });

    test('Attendance Status Logic - Late vs Present', () async {
      final helper = CheckInStatusHelper(mockIsar);

      final lateTime = DateTime(2026, 1, 30, 9, 30);
      expect(await helper.calculateStatus(lateTime), AttendanceStatus.late);

      final onTime = DateTime(2026, 1, 30, 8, 15);
      expect(await helper.calculateStatus(onTime), AttendanceStatus.present);
    });

    group('Mode GANAS (Field Duty)', () {
      test('Should bypass geofence but require notes and photo', () async {
        // 1. Setup GANAS Virtual Office
        final ganasOffice = OfficeLocationLocal()
          ..odId = 'ganas_mode'
          ..name = '⚠️ TUGAS LUAR / GANAS'
          ..radius = 999999;

        mockSelection.selectOffice(ganasOffice);
        expect(ganasManager.isGanasActive.value, true);

        mockLocManager.lastPosition = createPos(-7.0, 110.0); // Far away
        mockSelection.currentDistance.value = 50000.0;
        mockSelection.isInsideRadius.value =
            true; // Bypassed in SelectionManager

        // 2. Try submit without photo and notes
        await controller.validateAndSubmit();
        expect(mockRepo.saveCount, 0, reason: 'Should fail due to photo/notes');

        // 3. Add photo but no notes
        controller.cameraManager.capturedPhoto.value = File('test.jpg');
        await controller.validateAndSubmit();
        expect(mockRepo.saveCount, 0, reason: 'Should fail due to no notes');

        // 4. Add notes (too short)
        ganasManager.ganasNotes.value = 'abc';
        await controller.validateAndSubmit();
        expect(mockRepo.saveCount, 0, reason: 'Notes too short');

        // 5. Valid Happy Path GANAS
        ganasManager.ganasNotes.value = 'Perbaikan server di Jakarta';
        mockAuth.currentUser.value = UserLocal()..odId = 'u1';

        await controller.validateAndSubmit();

        expect(mockRepo.saveCount, 1);
        expect(mockRepo.lastSaved?.isGanas, true);
        expect(mockRepo.lastSaved?.ganasNotes, 'Perbaikan server di Jakarta');
      });
    });

    group('Lembur Anti-Nakal (Overtime Claim)', () {
      test('Threshold detection (60 mins)', () {
        final overtimeManager = Get.find<OvertimeManager>();
        final shiftEnd = DateTime(2026, 2, 6, 17, 0);

        // 59 mins -> Not reached
        expect(
            overtimeManager.isThresholdReached(
                shiftEnd.add(const Duration(minutes: 59)), shiftEnd),
            false);

        // 61 mins -> Reached
        expect(
            overtimeManager.isThresholdReached(
                shiftEnd.add(const Duration(minutes: 61)), shiftEnd),
            true);
      });

      test('Should perform normal checkout if within threshold', () async {
        controller.isCheckout.value = true;
        mockIsar.mockShift = ShiftLocal()
          ..odId = 's1'
          ..endTime = '17:00';
        mockIsar.mockTodayAttendance = AttendanceLocal()
          ..checkInTime = DateTime(2026, 2, 6, 8, 0)
          ..userId = 'default_user';

        final checkoutTime = DateTime(2026, 2, 6, 17, 30); // only 30 mins late
        mockTime.mockResult = TrustedTimeResult(
          time: checkoutTime,
          source: TimeSource.ntp,
          isManipulated: false,
          deviationSeconds: 0,
        );

        controller.cameraManager.capturedPhoto.value = File('test_photo.jpg');

        await controller.validateAndSubmit();

        expect(mockRepo.saveCount, 1);
        expect(mockRepo.lastSaved?.checkOutTime, checkoutTime);
        expect(mockRepo.lastSaved?.isOvertime, false);
      });

      test('Should trigger Trap (dialog) if threshold reached', () async {
        controller.isCheckout.value = true;
        mockIsar.mockUser = UserLocal()
          ..odId = 'default_user'
          ..shiftOdId = 's1';
        mockIsar.mockShift = ShiftLocal()
          ..odId = 's1'
          ..endTime = '17:00';
        mockIsar.mockTodayAttendance = AttendanceLocal()
          ..checkInTime = DateTime(2026, 2, 6, 8, 0)
          ..userId = 'default_user';

        final checkoutTime = DateTime(2026, 2, 6, 18, 30); // 90 mins late
        mockTime.mockResult = TrustedTimeResult(
          time: checkoutTime,
          source: TimeSource.ntp,
          isManipulated: false,
          deviationSeconds: 0,
        );
        controller.cameraManager.capturedPhoto.value = File('test_photo.jpg');

        // In test env (context null), it auto-caps to shiftEndTime
        await controller.validateAndSubmit();

        expect(mockRepo.saveCount, 1);
        expect(mockRepo.lastSaved?.isOvertime, false);
        // Shift end time for s1 is 17:00
        expect(mockRepo.lastSaved?.checkOutTime?.hour, 17);
        expect(mockRepo.lastSaved?.checkOutTime?.minute, 0);
      });
    });
  });
}
