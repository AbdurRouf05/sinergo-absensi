import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_device/safe_device.dart';
import 'package:geolocator/geolocator.dart';
import '../app/routes/app_routes.dart';
import 'package:logger/logger.dart';
import 'time_service.dart';

abstract class ISecurityService {
  Future<bool> performSecurityCheck();
}

class SecurityService extends GetxService
    with WidgetsBindingObserver
    implements ISecurityService {
  static SecurityService get to => Get.find();
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initSecurity();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _logger.i("[SecurityService] App Resumed - Re-verifying security...");
      performSecurityCheck();
    }
  }

  /// Standard GetxService initialization pattern
  Future<SecurityService> init() async {
    await initSecurity();
    return this;
  }

  /// Initialize security checks
  Future<void> initSecurity() async {
    _logger.i("[SecurityService] Initializing Security Service...");
    await performSecurityCheck();
  }

  /// THE GUARDIAN: Triple Lock Security Check
  /// Returns TRUE if device is SAFE.
  /// Returns FALSE if THREAT detected.
  @override
  Future<bool> performSecurityCheck() async {
    _logger.i("[SecurityService] Performing COMPREHENSIVE Security Check...");

    try {
      // 1. Root / Jailbreak Check
      bool isJailBroken = await SafeDevice.isJailBroken;
      _logger.i(
          "SECURITY CHECK: Root Status: ${isJailBroken ? 'DETECTED (UNSAFE)' : 'SAFE'}");

      if (isJailBroken) {
        _handleThreat(
          "Root Access / Jailbreak Detected",
          "Perangkat Anda terdeteksi telah dimodifikasi (Rooted). Sistem keamanan menolak akses untuk mencegah pencurian data.",
          "Kembalikan perangkat ke kondisi standar (Unroot) atau gunakan perangkat lain yang aman.",
        );
        return false;
      }

      // 2. Mock Location Check (DOUBLE LOCK)

      // Lock A: SafeDevice
      bool isSafeDeviceMock = await SafeDevice.isMockLocation;
      _logger.i(
          "SECURITY CHECK: Mock (SafeDevice): ${isSafeDeviceMock ? 'DETECTED' : 'SAFE'}");

      // Lock B: Geolocator (Anti-Freeze Implemented)
      bool isGeolocatorMock = false;

      // STEP 1: Permission Pre-Check (Prevent Freeze if denied)
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _logger.w("SECURITY CHECK: Mock (Geolocator): SKIPPED (No Permission)");
        // We do not force request permission here to avoid blocking startup flow unexpectedly.
        // We rely on 'SafeDevice' if permission is missing.
      } else {
        // STEP 2: Get Position with TIMEOUT (Anti-Freeze)
        try {
          // Wait max 5 seconds. If stuck, throw TimeoutException.
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 5),
          );

          isGeolocatorMock = position.isMocked;
          _logger.i(
              "SECURITY CHECK: Mock (Geolocator): ${isGeolocatorMock ? 'DETECTED' : 'SAFE'} (Lat: ${position.latitude}, Lng: ${position.longitude})");
        } catch (e) {
          // Fail-safe: If timeout or other error, log it but don't crash.
          _logger.w(
              "SECURITY CHECK: Mock (Geolocator): SKIPPED (Error/Timeout: $e)");
        }
      }

      // STEP 3: Double Lock Logic
      if (isSafeDeviceMock || isGeolocatorMock) {
        _handleThreat(
          "Lokasi Palsu Terdeteksi",
          "Sistem mendeteksi penggunaan Mock Location atau aplikasi Fake GPS. Presensi harus dilakukan dengan lokasi asli.",
          "1. Matikan aplikasi Fake GPS.\n2. Buka Settings > Developer Options > Select Mock Location App > Pilih 'None'.\n3. Restart HP jika perlu.",
        );
        return false;
      }

      // 3. Real Device Check (Optional, minimal log)
      bool isRealDevice = await SafeDevice.isRealDevice;
      _logger.i(
          "SECURITY CHECK: Real Device: ${isRealDevice ? 'YES' : 'NO/EMULATOR'}");

      // Strict Emulator Policy: Block emulator usage
      if (!isRealDevice) {
        _handleThreat(
          "Emulator Terdeteksi",
          "Aplikasi SINERGO.ID hanya diizinkan berjalan di perangkat fisik (HP) untuk validasi biometrik & lokasi yang akurat.",
          "Gunakan HP Android fisik (bukan Emulator/Virtual Machine) untuk melakukan presensi.",
        );
        return false;
      }

      // 4. TIME MANIPULATION CHECK (NEW!)
      try {
        if (Get.isRegistered<ITimeService>()) {
          final timeService = Get.find<ITimeService>();
          final isManipulated = await timeService.detectTimeManipulation();
          _logger.i(
              "SECURITY CHECK: Time Manipulation: ${isManipulated ? 'DETECTED (UNSAFE)' : 'SAFE'}");

          if (isManipulated) {
            _handleThreat(
              "Waktu Tidak Akurat",
              "Waktu perangkat Anda berbeda signifikan dengan waktu server. Manipulasi waktu tidak diizinkan.",
              "Buka Settings > Date & Time > Aktifkan 'Set Automatically' (Network-provided time).",
            );
            return false;
          }
        } else {
          _logger.w("SECURITY CHECK: Time: SKIPPED (TimeService not ready)");
        }
      } catch (e) {
        _logger.e("SECURITY CHECK: Time: SKIPPED", error: e);
      }
      return true; // SAFE
    } catch (e) {
      _logger.e("[Security] ERROR: Failed to perform security checks",
          error: e);
      // If check fails entirely, we default to SAFE to avoid locking out valid users due to bugs.
      // But in high security apps, you might default to UNSAFE.
      return true;
    }
  }

  /// Exposed method to report external threats (e.g. from AuthService)
  void reportThreat(String title, String message, String solution) {
    _handleThreat(title, message, solution);
  }

  void _handleThreat(String threatType, String threatMessage, String solution) {
    _logger.w("[Security] THREAT DETECTED: $threatType");

    // Navigate to Violation Screen if not already there
    if (Get.currentRoute != AppRoutes.securityViolation) {
      Get.offAllNamed(
        AppRoutes.securityViolation,
        arguments: {
          'threatType': threatType, // e.g., "Lokasi Palsu"
          'threatMessage': threatMessage, // Full explanation
          'solution': solution, // Actionable step
        },
      );
    }
  }
}
