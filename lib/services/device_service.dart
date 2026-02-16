import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/services/device/device_fingerprint_manager.dart';
import 'package:sinergo_app/services/device/device_id_manager.dart';

/// Interface for DeviceService to enable clean mocking in tests
abstract class IDeviceService {
  RxBool get isDeviceBound;
  RxBool get isDeviceCompromised;

  Future<String> getDeviceId();
  Future<Map<String, dynamic>> getDeviceFingerprint();
  Future<bool> validateDeviceBinding(String? registeredDeviceId);
  Future<bool> isNewDevice(String? registeredDeviceId);
}

/// DeviceService - Handles device identification and binding
class DeviceService extends GetxService implements IDeviceService {
  final Logger _logger = Logger();

  final DeviceIdManager _idManager = DeviceIdManager();
  final DeviceFingerprintManager _fingerprintManager =
      DeviceFingerprintManager();

  // Observable states
  @override
  final RxBool isDeviceBound = false.obs;
  @override
  RxBool get isDeviceCompromised => _fingerprintManager.isDeviceCompromised;

  /// Initialize the service
  Future<DeviceService> init() async {
    _logger.i('DeviceService initializing...');
    await _idManager.getDeviceId();
    await _fingerprintManager.checkDeviceIntegrity();
    return this;
  }

  @override
  Future<String> getDeviceId() async {
    return await _idManager.getDeviceId();
  }

  @override
  Future<Map<String, dynamic>> getDeviceFingerprint() async {
    final deviceId = await getDeviceId();
    return await _fingerprintManager.getDeviceFingerprint(deviceId);
  }

  /// Validate device binding with server
  @override
  Future<bool> validateDeviceBinding(String? registeredDeviceId) async {
    if (registeredDeviceId == null || registeredDeviceId.isEmpty) {
      _logger.i('No device registered for this user');
      isDeviceBound.value = false;
      return true; // Allow first-time binding
    }

    final currentDeviceId = await getDeviceId();
    final isMatch = currentDeviceId == registeredDeviceId;

    if (!isMatch) {
      _logger.w(
        'Device binding mismatch! '
        'Registered: ${registeredDeviceId.substring(0, 16)}... '
        'Current: ${currentDeviceId.substring(0, 16)}...',
      );
      isDeviceBound.value = false;
      throw DeviceBindingException(
        'Device tidak terdaftar. Hubungi HR untuk reset perangkat.',
        registeredDeviceId: registeredDeviceId,
        currentDeviceId: currentDeviceId,
      );
    }

    _logger.i('Device binding validated successfully');
    isDeviceBound.value = true;
    return true;
  }

  @override
  Future<bool> isNewDevice(String? registeredDeviceId) async {
    return registeredDeviceId == null || registeredDeviceId.isEmpty;
  }

  /// Clear stored device data (for testing/debug only)
  Future<void> clearDeviceData() async {
    _logger.w('Clearing device data...');
    await _idManager.clearDeviceData();
    _fingerprintManager.clear();
    isDeviceBound.value = false;
  }

  @override
  void onClose() {
    _logger.i('DeviceService closing...');
    super.onClose();
  }
}
