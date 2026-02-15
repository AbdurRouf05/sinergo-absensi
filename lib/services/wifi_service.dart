import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'permission_service.dart';

/// Interface for WifiService to enable clean mocking in tests
abstract class IWifiService {
  RxString get currentBssid;
  RxString get currentSsid;
  RxBool get isConnectedToWifi;
  RxBool get isOfficeWifi;

  Future<void> refreshWifiInfo();
  Future<String?> getFormattedBssid();
  Future<bool> isConnectedToOfficeWifi(List<String> allowedBssids);
}

/// WifiService - Handles WiFi BSSID validation for indoor presence
///
/// Features:
/// - Get current router BSSID (MAC address)
/// - Android 12+ permission handling for NEARBY_WIFI_DEVICES
/// - Returns null if on mobile data (not WiFi)
/// - Validates BSSID against allowed office networks
class WifiService extends GetxService implements IWifiService {
  final Logger _logger = Logger();
  final NetworkInfo _networkInfo = NetworkInfo();

  late IPermissionService _permissionService;

  // Observable states
  @override
  final RxString currentBssid = ''.obs;
  @override
  final RxString currentSsid = ''.obs;
  @override
  final RxBool isConnectedToWifi = false.obs;
  @override
  final RxBool isOfficeWifi = false.obs;

  /// Initialize the service
  Future<WifiService> init() async {
    _logger.i('WifiService initializing...');
    _permissionService = Get.find<IPermissionService>();

    // Initial check
    await refreshWifiInfo();

    return this;
  }

  /// Refresh current WiFi information
  @override
  Future<void> refreshWifiInfo() async {
    try {
      final bssid = await getFormattedBssid();
      final ssid = await getCurrentSsid();

      currentBssid.value = bssid ?? '';
      currentSsid.value = ssid ?? '';
      isConnectedToWifi.value = bssid != null && bssid.isNotEmpty;

      _logger.i('WiFi info refreshed: SSID=$ssid, BSSID=${_maskBssid(bssid)}');
    } catch (e) {
      _logger.e('Failed to refresh WiFi info', error: e);
      currentBssid.value = '';
      currentSsid.value = '';
      isConnectedToWifi.value = false;
    }
  }

  /// Get formatted BSSID (MAC address) of current router
  /// Returns null if not connected to WiFi or on mobile data
  @override
  Future<String?> getFormattedBssid() async {
    try {
      // Check if we have location permission (required for WiFi info on Android)
      if (!_permissionService.hasLocationPermission.value) {
        _logger.w('Location permission not granted, cannot get BSSID');
        return null;
      }

      // On Android 12+ (API 31), we need NEARBY_WIFI_DEVICES permission
      // But network_info_plus handles this gracefully
      String? bssid;

      if (Platform.isAndroid) {
        bssid = await _networkInfo.getWifiBSSID();
      } else if (Platform.isIOS) {
        // iOS requires specific entitlements
        bssid = await _networkInfo.getWifiBSSID();
      }

      // Check if valid BSSID
      if (bssid == null ||
          bssid.isEmpty ||
          bssid == '02:00:00:00:00:00' || // Default/masked BSSID
          bssid == '00:00:00:00:00:00') {
        _logger.i('Not connected to WiFi or BSSID not available');
        return null;
      }

      // Format BSSID to uppercase for consistency
      return bssid.toUpperCase();
    } catch (e) {
      _logger.e('Error getting BSSID', error: e);
      return null;
    }
  }

  /// Get current SSID (WiFi name)
  Future<String?> getCurrentSsid() async {
    try {
      if (!_permissionService.hasLocationPermission.value) {
        return null;
      }

      String? ssid = await _networkInfo.getWifiName();

      // Remove quotes if present (Android sometimes adds them)
      if (ssid != null) {
        ssid = ssid.replaceAll('"', '');
        if (ssid == '<unknown ssid>') {
          return null;
        }
      }

      return ssid;
    } catch (e) {
      _logger.e('Error getting SSID', error: e);
      return null;
    }
  }

  /// Get current WiFi IP address
  Future<String?> getWifiIpAddress() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (e) {
      _logger.e('Error getting WiFi IP', error: e);
      return null;
    }
  }

  /// Validate if current BSSID matches any allowed office BSSIDs
  bool validateBssid(String? currentBssid, List<String> allowedBssids) {
    if (currentBssid == null || currentBssid.isEmpty) {
      return false;
    }

    final normalizedCurrent = currentBssid.toUpperCase().trim();

    for (final allowed in allowedBssids) {
      if (allowed.toUpperCase().trim() == normalizedCurrent) {
        _logger.i(
          'BSSID validated: ${_maskBssid(normalizedCurrent)} matches office WiFi',
        );
        return true;
      }
    }

    _logger.w('BSSID ${_maskBssid(normalizedCurrent)} not in allowed list');
    return false;
  }

  /// Check if currently connected to one of the allowed office WiFi networks
  @override
  Future<bool> isConnectedToOfficeWifi(List<String> allowedBssids) async {
    final bssid = await getFormattedBssid();
    final isOffice = validateBssid(bssid, allowedBssids);
    isOfficeWifi.value = isOffice;
    return isOffice;
  }

  /// Mask BSSID for logging (privacy)
  String _maskBssid(String? bssid) {
    if (bssid == null || bssid.length < 8) return '***';
    return '${bssid.substring(0, 8)}:XX:XX:XX';
  }

  /// Get full WiFi connection info for audit trail
  Future<Map<String, dynamic>> getWifiInfo() async {
    return {
      'bssid': await getFormattedBssid(),
      'ssid': await getCurrentSsid(),
      'ip': await getWifiIpAddress(),
      'is_connected': isConnectedToWifi.value,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  @override
  void onClose() {
    _logger.i('WifiService closing...');
    super.onClose();
  }
}
