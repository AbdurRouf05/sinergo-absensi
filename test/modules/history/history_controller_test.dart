import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:sinergo_app/modules/history/history_controller.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/sync_service.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';

// Manual Mocks
class MockIsarService extends Mock implements IsarService {
  @override
  Future<List<AttendanceLocal>> getAttendanceHistory(
    String? userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int offset = 0,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#getAttendanceHistory, [
        userId
      ], {
        #startDate: startDate,
        #endDate: endDate,
        #limit: limit,
      }),
      returnValue: Future.value(<AttendanceLocal>[]),
      returnValueForMissingStub: Future.value(<AttendanceLocal>[]),
    ) as Future<List<AttendanceLocal>>;
  }
}

class MockAuthService extends Mock implements AuthService {
  @override
  final Rx<UserLocal?> currentUser = Rx<UserLocal?>(null);
}

class MockSyncService extends Mock implements SyncService {
  @override
  final RxString syncStatus = 'idle'.obs;
}

void main() {
  late HistoryController controller;
  late MockIsarService mockIsarService;
  late MockAuthService mockAuthService;
  late MockSyncService mockSyncService;

  setUp(() {
    Get.testMode = true;
    mockIsarService = MockIsarService();
    mockAuthService = MockAuthService();
    mockSyncService = MockSyncService();

    // Register mocks
    Get.put<IsarService>(mockIsarService);
    Get.put<AuthService>(mockAuthService);
    Get.put<SyncService>(mockSyncService);
  });

  tearDown(() {
    Get.reset();
  });

  test('Initial state should be loading', () {
    // We can't easily test onInit because Get.put immediately initializes if we are not careful
    // But we can check after initialization
    mockAuthService.currentUser.value = UserLocal()..odId = 'user1';
    controller = HistoryController(
        isarService: mockIsarService, authService: mockAuthService);
    expect(controller.isLoading.value, true);
  });

  test('loadHistory should populate records from IsarService', () async {
    // Arrange
    mockAuthService.currentUser.value = UserLocal()..odId = 'user123';
    final dummyRecords = [
      AttendanceLocal()..userId = 'user123',
      AttendanceLocal()..userId = 'user123'
    ];

    when(mockIsarService.getAttendanceHistory(
      'user123',
      startDate: anyNamed('startDate'),
      endDate: anyNamed('endDate'),
      limit: anyNamed('limit'),
    )).thenAnswer((_) async => dummyRecords);

    // Act
    controller = HistoryController(
        isarService: mockIsarService,
        authService: mockAuthService); // onInit calls loadHistory

    // Manually trigger onInit for testing if not using Get.put
    controller.onInit();

    await Future.delayed(
        const Duration(milliseconds: 100)); // wait for loadHistory

    // Assert
    expect(controller.attendanceRecords.length, 2);
    expect(controller.hasError.value, false);
    verify(mockIsarService.getAttendanceHistory(any,
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            limit: anyNamed('limit')))
        .called(greaterThanOrEqualTo(1));
  });

  test('loadHistory should show error when user not logged in', () async {
    mockAuthService.currentUser.value = null;
    controller = HistoryController(
        isarService: mockIsarService, authService: mockAuthService);
    controller.onInit();
    await Future.delayed(
        const Duration(milliseconds: 100)); // wait for loadHistory

    // Assert
    expect(controller.hasError.value, true);
    expect(controller.errorMessage.value, contains('login'));
  });
}
