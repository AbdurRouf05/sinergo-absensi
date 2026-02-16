import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/modules/admin/controllers/leave_approval_controller.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';
import 'package:sinergo_app/modules/admin/views/widgets/leave_request_card.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';

class LeaveApprovalView extends StatelessWidget {
  const LeaveApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(LeaveApprovalController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Persetujuan Izin"),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: "PENDING"),
              Tab(text: "APPROVED"),
              Tab(text: "REJECTED"),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              _buildList(controller.pendingList, controller,
                  showActions: true, emptyMsg: "Tidak ada izin pending"),
              _buildList(controller.approvedList, controller,
                  showActions: false, emptyMsg: "Belum ada izin disetujui"),
              _buildList(controller.rejectedList, controller,
                  showActions: false, emptyMsg: "Belum ada izin ditolak"),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildList(
      List<LeaveRequestLocal> items, LeaveApprovalController controller,
      {required bool showActions, required String emptyMsg}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(emptyMsg, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final user = controller.userMap[item.userId];
        return LeaveRequestCard(
            item: item,
            user: user,
            controller: controller,
            showActions: showActions);
      },
    );
  }
}
