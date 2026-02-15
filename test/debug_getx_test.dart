import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:attendance_fusion/services/device_service.dart';

class MockDeviceService extends Mock implements DeviceService {
  @override
  final RxBool isDeviceCompromised = false.obs;

  @override
  InternalFinalCallback<void> get onStart => InternalFinalCallback<void>();
  @override
  InternalFinalCallback<void> get onDelete => InternalFinalCallback<void>();
}

void main() {
  test('Get.put minimal debug', () {
    debugPrint('Starting Get.put test...');
    try {
      final mock = MockDeviceService();
      debugPrint('Mock created: $mock');
      Get.put<DeviceService>(mock);
      debugPrint('Get.put successful');
      final found = Get.find<DeviceService>();
      debugPrint('Get.find successful: $found');
      expect(found, mock);
    } catch (e, stack) {
      debugPrint('ERROR: $e');
      debugPrint('STACK: $stack');
      rethrow;
    }
  });
}
