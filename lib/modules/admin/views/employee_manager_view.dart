import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';
import 'package:sinergo_app/modules/admin/views/employee_detail_view.dart';
import 'package:sinergo_app/modules/admin/views/employees/add_employee_view.dart';

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
          child: ListView.builder(
            itemCount: controller.employees.length,
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2.5),
          ),
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              (name.isNotEmpty) ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(displayEmail,
                style: TextStyle(
                  color: isPlaceholder ? Colors.grey : Colors.black87,
                  fontStyle:
                      isPlaceholder ? FontStyle.italic : FontStyle.normal,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: 4),
            if (hasDevice)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.success, width: 1.5),
                ),
                child: Text(
                    "Device Bound: ${devId.length > 8 ? devId.substring(0, 8) : devId}...",
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold)),
              ),
            if (!hasDevice)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: const Text("No Device Bound",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: hasDevice
                ? AppColors.success.withValues(alpha: 0.1)
                : Colors.grey[200],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Icon(
            hasDevice ? Icons.phonelink_lock : Icons.phone_android,
            color: hasDevice ? AppColors.success : Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }
}
