import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class DeviceFingerprintManager {
  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  final RxBool isDeviceCompromised = false.obs;
  Map<String, dynamic>? _deviceFingerprint;

  Future<Map<String, dynamic>> getDeviceFingerprint(String deviceId) async {
    if (_deviceFingerprint != null) return _deviceFingerprint!;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        _deviceFingerprint = {
          'platform': 'android',
          'device_id': deviceId,
          'brand': androidInfo.brand,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'sdk_version': androidInfo.version.sdkInt,
          'android_version': androidInfo.version.release,
          'is_physical_device': androidInfo.isPhysicalDevice,
          'fingerprint': androidInfo.fingerprint,
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        _deviceFingerprint = {
          'platform': 'ios',
          'device_id': deviceId,
          'model': iosInfo.model,
          'system_name': iosInfo.systemName,
          'system_version': iosInfo.systemVersion,
          'is_physical_device': iosInfo.isPhysicalDevice,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }
      return _deviceFingerprint ?? {};
    } catch (e) {
      _logger.e('Failed to get device fingerprint', error: e);
      return {'error': 'Failed to get device fingerprint'};
    }
  }

  Future<void> checkDeviceIntegrity() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        final suspiciousIndicators = <String>[];

        if (!androidInfo.isPhysicalDevice) {
          suspiciousIndicators.add('emulator');
        }

        final fingerprint = androidInfo.fingerprint.toLowerCase();
        if (fingerprint.contains('test-keys') ||
            fingerprint.contains('generic')) {
          suspiciousIndicators.add('test_build');
        }

        final tags = androidInfo.tags.toLowerCase();
        if (tags.contains('test-keys')) {
          suspiciousIndicators.add('test_keys');
        }

        if (suspiciousIndicators.isNotEmpty) {
          _logger.w('Suspicious device indicators: $suspiciousIndicators');
          isDeviceCompromised.value = true;
        } else {
          isDeviceCompromised.value = false;
        }
      }
    } catch (e) {
      _logger.e('Device integrity check failed', error: e);
      isDeviceCompromised.value = false;
    }
  }

  void clear() {
    _deviceFingerprint = null;
    isDeviceCompromised.value = false;
  }
}
