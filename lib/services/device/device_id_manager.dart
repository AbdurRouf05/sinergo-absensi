import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/core/constants/app_constants.dart';
import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:uuid/uuid.dart';

class DeviceIdManager {
  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  String? _deviceId;

  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    // Try to get from secure storage first
    final storedId = await _secureStorage.read(key: AppConstants.deviceIdKey);
    if (storedId != null) {
      _deviceId = storedId;
      return _deviceId!;
    }

    // Generate new device ID
    await _generateDeviceId();
    return _deviceId!;
  }

  Future<void> _generateDeviceId() async {
    try {
      String rawId;

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        rawId = '${androidInfo.id}_${androidInfo.model}_${androidInfo.brand}';
        _logger.i('Android info: ${androidInfo.model}');
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        rawId =
            '${iosInfo.identifierForVendor}_${iosInfo.model}_${iosInfo.name}';
      } else {
        throw const DeviceBindingException('Unsupported platform');
      }

      // Hash the raw ID
      final bytes = utf8.encode(rawId);
      final hash = sha256.convert(bytes);
      _deviceId = hash.toString();

      // Store in secure storage
      await _secureStorage.write(
        key: AppConstants.deviceIdKey,
        value: _deviceId,
      );

      _logger.i('Device ID generated: ${_deviceId!.substring(0, 16)}...');
    } catch (e) {
      _logger.e('Failed to generate Device ID, fallback to UUID', error: e);
      _deviceId = const Uuid().v4();
      await _secureStorage.write(
        key: AppConstants.deviceIdKey,
        value: _deviceId,
      );
    }
  }

  Future<void> clearDeviceData() async {
    await _secureStorage.delete(key: AppConstants.deviceIdKey);
    _deviceId = null;
  }
}
