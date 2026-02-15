import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/modules/admin/controllers/admin_controller.dart';
import 'package:attendance_fusion/modules/admin/views/widgets/overtime_request_card.dart';

class OvertimeApprovalView extends StatelessWidget {
  const OvertimeApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Persetujuan Lembur"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingOvertimeList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history_toggle_off,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  "Tidak ada pengajuan lembur pending",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchPendingOvertime(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pendingOvertimeList.length,
            itemBuilder: (context, index) {
              return OvertimeRequestCard(
                item: controller.pendingOvertimeList[index],
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }
}
