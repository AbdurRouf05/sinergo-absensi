import 'package:get/get.dart';

// Services
import '../../services/permission_service.dart';
import '../../services/device_service.dart';
import '../../services/isar_service.dart';
import '../../services/auth_service.dart';
import '../../services/wifi_service.dart';
import '../../services/location_service.dart';
import '../../services/time_service.dart';
import '../../services/sync_service.dart';
import '../../services/connectivity_service.dart'; // Added
import '../../services/security_service.dart';

// Repositories
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/leave_repository.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/interfaces/i_admin_repository.dart';
import '../../data/repositories/notification_repository.dart';

// Local Repositories
import '../../data/repositories/local/user_local_repository.dart';
import '../../data/repositories/local/attendance_local_repository.dart';
import '../../data/repositories/local/office_local_repository.dart';
import '../../data/repositories/local/hr_local_repository.dart';
import '../../data/repositories/local/sync_queue_repository.dart';
import '../../data/repositories/local/notification_local_repository.dart';

/// InitialBinding - Initializes all core services at app startup
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services - lazy loaded using interfaces
    Get.lazyPut<IPermissionService>(() => PermissionService(), fenix: true);
    Get.lazyPut<IDeviceService>(() => DeviceService(), fenix: true);
    Get.lazyPut<IIsarService>(() => IsarService(), fenix: true);
    Get.lazyPut<IWifiService>(() => WifiService(), fenix: true);
    Get.lazyPut<ILocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<ITimeService>(() => TimeService(), fenix: true);
    Get.lazyPut<IAuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<ISyncService>(() => SyncService(), fenix: true);

    // Repositories
    Get.lazyPut<IUserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<IAttendanceRepository>(() => AttendanceRepository(),
        fenix: true);
    Get.lazyPut<ILeaveRepository>(() => LeaveRepository(), fenix: true);
    Get.lazyPut<IAdminRepository>(() => AdminRepository(), fenix: true);
    Get.lazyPut<INotificationRepository>(() => NotificationRepository(),
        fenix: true);
  }
}

/// Initialize all services (call this in main.dart before runApp)
Future<void> initializeServices() async {
  // Phase 0: CORE INFRASTRUCTURE
  await Get.putAsync<IPermissionService>(
    () => PermissionService().init(),
    permanent: true,
  );

  await Get.putAsync<ISecurityService>(
    () => SecurityService().init(),
    permanent: true,
  );

  await Get.putAsync<IDeviceService>(
    () => DeviceService().init(),
    permanent: true,
  );

  // Isar Service (Must be available for Local Repos)
  final isarService = await Get.putAsync<IIsarService>(
    () => IsarService().init(),
    permanent: true,
  );

  // Register Local Repositories directly from IsarService
  final concreteIsar = isarService as IsarService;
  Get.put<UserLocalRepository>(concreteIsar.userRepo, permanent: true);
  Get.put<AttendanceLocalRepository>(concreteIsar.attendanceRepo,
      permanent: true);
  Get.put<OfficeLocalRepository>(concreteIsar.officeRepo, permanent: true);
  Get.put<ShiftLocalRepository>(concreteIsar.shiftRepo, permanent: true);
  Get.put<LeaveLocalRepository>(concreteIsar.leaveRepo, permanent: true);
  Get.put<SyncQueueRepository>(concreteIsar.syncRepo, permanent: true);
  Get.put<NotificationLocalRepository>(concreteIsar.notificationRepo,
      permanent: true);

  // Phase 2: Sensor and Logic services
  await Get.putAsync<IWifiService>(() => WifiService().init(), permanent: true);
  await Get.putAsync<ILocationService>(() => LocationService().init(),
      permanent: true);
  await Get.putAsync<ITimeService>(() => TimeService().init(), permanent: true);

  // Phase 3: Core Orchestrators (Auth & Sync)
  await Get.putAsync<IAuthService>(() => AuthService().init(), permanent: true);
  await Get.putAsync<ISyncService>(() => SyncService().init(), permanent: true);
  Get.put(ConnectivityService(), permanent: true); // Added ConnectivityService

  // Phase 4: Domain Repositories (Depends on Phase 3)
  Get.put<IUserRepository>(UserRepository(), permanent: true);
  Get.put<IAttendanceRepository>(AttendanceRepository(), permanent: true);
  Get.put<ILeaveRepository>(LeaveRepository(), permanent: true);
  Get.put<IAdminRepository>(AdminRepository(), permanent: true);
  Get.put<INotificationRepository>(NotificationRepository(), permanent: true);
}
