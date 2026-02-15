import 'package:get/get.dart';
import 'package:attendance_fusion/data/repositories/attendance_repository.dart';

import 'home_controller.dart';
import '../history/history_binding.dart';
import '../notifications/notification_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAttendanceRepository>(() => AttendanceRepository());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<NotificationController>(NotificationController(), permanent: true);
    HistoryBinding().dependencies();
  }
}
