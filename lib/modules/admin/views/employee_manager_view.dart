import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/modules/admin/controllers/admin_controller.dart';
import 'package:attendance_fusion/app/theme/app_colors.dart';
import 'package:attendance_fusion/modules/admin/views/employee_detail_view.dart';
import 'package:attendance_fusion/modules/admin/views/employees/add_employee_view.dart';

class EmployeeManagerView extends GetView<AdminController> {
  const EmployeeManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manajemen Karyawan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshEmployees();
          },
          child: ListView.separated(
            itemCount: controller.employees.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = controller.employees[index];
              return InkWell(
                onTap: () => Get.to(() => EmployeeDetailView(employee: user)),
                child: _buildEmployeeTile(user),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.to(() => const AddEmployeeView()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmployeeTile(UserLocal user) {
    // fields from UserLocal
    final name = user.name.isNotEmpty ? user.name : 'Unnamed';

    // UX Fix: Show full email OR hide placeholder
    String displayEmail = user.email;
    bool isPlaceholder = user.email.contains("@local.placeholder");

    if (isPlaceholder) {
      displayEmail = "Email Hidden (Privacy)";
    }

    final devId = user.registeredDeviceId ?? '';
    final hasDevice = devId.isNotEmpty;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Text(
          (name.isNotEmpty) ? name[0].toUpperCase() : 'U',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(displayEmail,
              style: TextStyle(
                color: isPlaceholder ? Colors.grey : Colors.black87,
                fontStyle: isPlaceholder ? FontStyle.italic : FontStyle.normal,
              )),
          if (hasDevice)
            Text(
                "Device Bound: ${devId.length > 8 ? devId.substring(0, 8) : devId}...",
                style: const TextStyle(fontSize: 10, color: Colors.green)),
          if (!hasDevice)
            const Text("No Device Bound",
                style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
      // OLD: Reset device button moved to EmployeeDetailView (Danger Zone section)
      // trailing: hasDevice
      //     ? IconButton(
      //         icon: const Icon(Icons.phonelink_erase, color: Colors.red),
      //         onPressed: () => controller.resetDevice(user.odId, user.name),
      //         tooltip: "Reset Device ID",
      //       )
      //     : const Icon(Icons.check_circle, color: Colors.green),
      // NEW: Simple status indicator (tap tile to go to detail for actions)
      trailing: Icon(
        hasDevice ? Icons.phonelink_lock : Icons.phone_android,
        color: hasDevice ? AppColors.primary : Colors.grey,
        size: 20,
      ),
    );
  }
}
