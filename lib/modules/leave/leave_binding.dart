import 'package:get/get.dart';
import 'package:attendance_fusion/modules/leave/leave_controller.dart';
import 'package:attendance_fusion/data/repositories/leave_repository.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ILeaveRepository>(() => LeaveRepository());
    Get.lazyPut<LeaveController>(() => LeaveController());
  }
}
