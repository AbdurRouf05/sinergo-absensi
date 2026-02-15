import 'package:get/get.dart';
import 'checkout_controller.dart';
import '../../../services/device_service.dart';
import '../../../services/location_service.dart';
import '../../../services/wifi_service.dart';
import '../../../services/time_service.dart';
import '../../../services/isar_service.dart';
import '../../../data/repositories/attendance_repository.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(
        deviceService: Get.find<IDeviceService>(),
        locationService: Get.find<ILocationService>(),
        wifiService: Get.find<IWifiService>(),
        timeService: Get.find<ITimeService>(),
        isarService: Get.find<IIsarService>(),
        attendanceRepository: Get.find<IAttendanceRepository>(),
      ),
    );
  }
}
