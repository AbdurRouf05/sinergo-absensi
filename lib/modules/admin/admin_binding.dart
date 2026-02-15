import 'package:get/get.dart';
import 'package:attendance_fusion/modules/admin/controllers/admin_controller.dart';
import 'package:attendance_fusion/modules/admin/controllers/leave_approval_controller.dart';
import 'package:attendance_fusion/modules/admin/controllers/live_attendance_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<LeaveApprovalController>(() => LeaveApprovalController());
    Get.lazyPut<LiveAttendanceController>(() => LiveAttendanceController());
  }
}
