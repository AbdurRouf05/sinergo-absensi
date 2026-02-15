import 'package:get/get.dart';
import 'package:attendance_fusion/modules/admin/analytics/analytics_controller.dart';
import 'package:attendance_fusion/data/repositories/admin_repository.dart';
import 'package:attendance_fusion/data/repositories/interfaces/i_admin_repository.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure Repo is available for the Controller
    Get.lazyPut<IAdminRepository>(() => AdminRepository());
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}
