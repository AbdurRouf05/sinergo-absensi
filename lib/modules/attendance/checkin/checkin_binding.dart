import 'package:get/get.dart';

import 'checkin_controller.dart';
import '../../../data/repositories/attendance_repository.dart';

class CheckinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAttendanceRepository>(() => AttendanceRepository());
    Get.lazyPut<CheckinController>(() => CheckinController());
  }
}
