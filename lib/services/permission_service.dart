import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';

/// PermissionService - Handles all permission requests with Android version awareness
///
/// Critical for Android 7+ compatibility:
/// - Android 13+ (API 33): Requires POST_NOTIFICATIONS permission
/// - Android 7-12: No notification permission needed
/// - Handles graceful fallbacks for denied permissions
/// Interface for PermissionService
abstract class IPermissionService {
  RxBool get hasLocationPermission;
  RxBool get hasCameraPermission;
  RxBool get hasNotificationPermission;
  RxBool get hasBackgroundLocationPermission;
  bool get hasAllRequiredPermissions;
  Future<PermissionStatus> requestLocationPermission();
  Future<PermissionStatus> requestCameraPermission();
  Future<PermissionStatus> requestNotificationPermission();
  Future<Map<String, PermissionStatus>> requestAllAttendancePermissions();
  Future<bool> openSettings();
}

class PermissionService extends GetxService implements IPermissionService {
  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Observable permission states
  @override
  final RxBool hasLocationPermission = false.obs;
  @override
  final RxBool hasCameraPermission = false.obs;
  @override
  final RxBool hasNotificationPermission = false.obs;
  @override
  final RxBool hasBackgroundLocationPermission = false.obs;

  // Android SDK version cache
  int? _androidSdkVersion;

  /// Initialize service and check current permissions
  Future<PermissionService> init() async {
    _logger.i('PermissionService initializing...');

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      _androidSdkVersion = androidInfo.version.sdkInt;
      _logger.i('Android SDK Version: $_androidSdkVersion');
    }

    await _checkCurrentPermissions();
    return this;
  }

  /// Get Android SDK version (cached)
  int get androidSdkVersion => _androidSdkVersion ?? 24;

  /// Check if device is Android 13+ (API 33)
  bool get isAndroid13OrHigher =>
      _androidSdkVersion != null && _androidSdkVersion! >= 33;

  /// Check if device is Android 10+ (API 29)
  bool get isAndroid10OrHigher =>
      _androidSdkVersion != null && _androidSdkVersion! >= 29;

  /// Check all current permission states
  Future<void> _checkCurrentPermissions() async {
    hasLocationPermission.value = await Permission.location.isGranted;
    hasCameraPermission.value = await Permission.camera.isGranted;

    if (isAndroid13OrHigher) {
      hasNotificationPermission.value = await Permission.notification.isGranted;
    } else {
      // Pre-Android 13: notifications don't need permission
      hasNotificationPermission.value = true;
    }

    if (isAndroid10OrHigher) {
      hasBackgroundLocationPermission.value =
          await Permission.locationAlways.isGranted;
    } else {
      // Pre-Android 10: background location included with regular location
      hasBackgroundLocationPermission.value = hasLocationPermission.value;
    }

    _logger.i(
      'Permission states checked: '
      'location=${hasLocationPermission.value}, '
      'camera=${hasCameraPermission.value}, '
      'notification=${hasNotificationPermission.value}, '
      'backgroundLocation=${hasBackgroundLocationPermission.value}',
    );
  }

  /// Request location permission (foreground)
  @override
  Future<PermissionStatus> requestLocationPermission() async {
    _logger.i('Requesting location permission...');

    final status = await Permission.location.request();
    hasLocationPermission.value = status.isGranted;

    _logger.i('Location permission result: $status');
    return status;
  }

  /// Request background location permission (Android 10+)
  /// Must be called AFTER foreground location is granted
  Future<PermissionStatus> requestBackgroundLocationPermission() async {
    if (!isAndroid10OrHigher) {
      _logger.i('Background location not needed for SDK < 29');
      hasBackgroundLocationPermission.value = hasLocationPermission.value;
      return hasLocationPermission.value
          ? PermissionStatus.granted
          : PermissionStatus.denied;
    }

    // Foreground location must be granted first
    if (!hasLocationPermission.value) {
      _logger.w(
        'Cannot request background location without foreground location',
      );
      return PermissionStatus.denied;
    }

    _logger.i('Requesting background location permission...');
    final status = await Permission.locationAlways.request();
    hasBackgroundLocationPermission.value = status.isGranted;

    _logger.i('Background location permission result: $status');
    return status;
  }

  /// Request camera permission
  @override
  Future<PermissionStatus> requestCameraPermission() async {
    _logger.i('Requesting camera permission...');

    final status = await Permission.camera.request();
    hasCameraPermission.value = status.isGranted;

    _logger.i('Camera permission result: $status');
    return status;
  }

  /// Request notification permission (Android 13+ only)
  @override
  Future<PermissionStatus> requestNotificationPermission() async {
    if (!isAndroid13OrHigher) {
      _logger.i('Notification permission not needed for SDK < 33');
      hasNotificationPermission.value = true;
      return PermissionStatus.granted;
    }

    _logger.i('Requesting notification permission (Android 13+)...');
    final status = await Permission.notification.request();
    hasNotificationPermission.value = status.isGranted;

    _logger.i('Notification permission result: $status');
    return status;
  }

  /// Request all permissions needed for attendance
  /// Returns map of permission name to status
  @override
  Future<Map<String, PermissionStatus>>
      requestAllAttendancePermissions() async {
    _logger.i('Requesting all attendance permissions...');

    final results = <String, PermissionStatus>{};

    // Location (required)
    results['location'] = await requestLocationPermission();

    // Camera (required for photo)
    results['camera'] = await requestCameraPermission();

    // Notification (Android 13+ only)
    results['notification'] = await requestNotificationPermission();

    // Background location (optional, for geofencing)
    if (results['location']!.isGranted) {
      results['backgroundLocation'] =
          await requestBackgroundLocationPermission();
    }

    _logger.i('All permissions requested: $results');
    return results;
  }

  /// Check if all critical permissions are granted
  @override
  bool get hasAllRequiredPermissions {
    return hasLocationPermission.value && hasCameraPermission.value;
  }

  /// Open app settings if permissions are permanently denied
  @override
  Future<bool> openSettings() async {
    _logger.i('Opening app settings...');
    return openAppSettings();
  }

  /// Get human-readable permission status message
  String getPermissionMessage(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Izin diberikan';
      case PermissionStatus.denied:
        return 'Izin ditolak';
      case PermissionStatus.permanentlyDenied:
        return 'Izin ditolak permanen. Buka pengaturan untuk mengaktifkan.';
      case PermissionStatus.restricted:
        return 'Izin dibatasi oleh sistem';
      case PermissionStatus.limited:
        return 'Izin terbatas';
      case PermissionStatus.provisional:
        return 'Izin sementara';
    }
  }

  @override
  void onClose() {
    _logger.i('PermissionService closing...');
    super.onClose();
  }
}
