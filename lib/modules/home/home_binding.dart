import 'package:get/get.dart';
import 'package:sinergo_app/data/repositories/attendance_repository.dart';

import 'home_controller.dart';
import '../history/history_binding.dart';
import '../notifications/notification_controller.dart';
import '../../services/smart_recap_service.dart';
import '../../services/notification_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAttendanceRepository>(() => AttendanceRepository());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SmartRecapService>(() => SmartRecapService());
    Get.put<NotificationService>(NotificationService(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);
    HistoryBinding().dependencies();
  }
}
