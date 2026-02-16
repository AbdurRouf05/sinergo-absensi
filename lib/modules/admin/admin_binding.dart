import 'package:get/get.dart';
import 'package:sinergo_app/data/repositories/admin_dashboard_repository.dart';
import 'package:sinergo_app/data/repositories/admin_recap_repository.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';
import 'package:sinergo_app/modules/admin/controllers/leave_approval_controller.dart';
import 'package:sinergo_app/modules/admin/controllers/live_attendance_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardRepository>(() => AdminDashboardRepository());
    Get.lazyPut<AdminRecapRepository>(() => AdminRecapRepository());

    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<LeaveApprovalController>(() => LeaveApprovalController());
    Get.lazyPut<LiveAttendanceController>(() => LiveAttendanceController());
  }
}
