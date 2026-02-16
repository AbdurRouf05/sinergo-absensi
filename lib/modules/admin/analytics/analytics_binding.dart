import 'package:get/get.dart';
import 'package:sinergo_app/modules/admin/analytics/analytics_controller.dart';
import 'package:sinergo_app/data/repositories/admin_repository.dart';
import 'package:sinergo_app/data/repositories/interfaces/i_admin_repository.dart';

class AnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure Repo is available for the Controller
    Get.lazyPut<IAdminRepository>(() => AdminRepository());
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}
