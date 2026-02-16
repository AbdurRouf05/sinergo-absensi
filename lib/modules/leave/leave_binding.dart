import 'package:get/get.dart';
import 'package:sinergo_app/modules/leave/leave_controller.dart';
import 'package:sinergo_app/data/repositories/leave_repository.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ILeaveRepository>(() => LeaveRepository());
    Get.lazyPut<LeaveController>(() => LeaveController());
  }
}
