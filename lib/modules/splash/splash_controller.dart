import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/permission_service.dart';
import '../../services/security_service.dart';
import '../../core/errors/app_exceptions.dart';

/// SplashController - Handles app initialization and navigation
///
/// Enforces a minimum display time so the splash animation
/// can complete before navigating away.
class SplashController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final IPermissionService _permissionService = Get.find<IPermissionService>();

  /// Minimum time the splash screen is shown (allows animation to complete).
  static const _minDisplayDuration = Duration(seconds: 4);

  // Observable states
  final RxString statusMessage = 'Memulai aplikasi...'.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDeviceBlocked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Start a timer so we know when minDisplayDuration has elapsed
    final stopwatch = Stopwatch()..start();

    try {
      // Step 0: Security Check (BLOCKING INIT)
      statusMessage.value = 'Memeriksa keamanan perangkat...';
      final securityService = Get.find<ISecurityService>();
      final isDeviceSafe = await securityService.performSecurityCheck();

      if (!isDeviceSafe) {
        // SecurityService handles navigation to Violation Screen.
        return;
      }

      // Step 1: Check permissions
      statusMessage.value = 'Memeriksa izin aplikasi...';
      await Future.delayed(const Duration(milliseconds: 800));

      // Step 2: Check auth status
      statusMessage.value = 'Memeriksa sesi login...';
      await Future.delayed(const Duration(milliseconds: 800));

      // Step 3: Determine destination
      final String destination;
      if (_authService.isAuthenticated.value) {
        statusMessage.value = 'Selamat datang kembali!';
        destination = AppRoutes.home;
      } else {
        statusMessage.value = 'Silakan login untuk melanjutkan';
        destination = AppRoutes.login;
      }

      // Wait for remaining minimum display time
      stopwatch.stop();
      final elapsed = stopwatch.elapsed;
      if (elapsed < _minDisplayDuration) {
        await Future.delayed(_minDisplayDuration - elapsed);
      }

      // Navigate
      Get.offAllNamed(destination);
    } on DeviceBindingException catch (e) {
      hasError.value = true;
      isDeviceBlocked.value = true;
      errorMessage.value = e.message;
      statusMessage.value = 'Perangkat Diblokir';
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      statusMessage.value = 'Terjadi kesalahan';
    }
  }

  /// Retry initialization
  void retry() {
    hasError.value = false;
    errorMessage.value = '';
    isDeviceBlocked.value = false;
    _initialize();
  }

  /// Request permissions
  Future<void> requestPermissions() async {
    statusMessage.value = 'Meminta izin aplikasi...';
    await _permissionService.requestAllAttendancePermissions();
    _initialize();
  }
}
