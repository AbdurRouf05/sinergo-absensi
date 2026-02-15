import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:attendance_fusion/data/models/notification_model.dart';
import '../../app/theme/app_colors.dart';
import 'notification_controller.dart';
import 'widgets/notification_card.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.bgLight,
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshNotifications(),
          child: ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return NotificationCard(
                item: item,
                onTap: () => _showNotificationDetail(item),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: AppColors.grey400),
          SizedBox(height: 16),
          Text(
            "Belum ada notifikasi",
            style: TextStyle(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetail(NotificationLocal item) {
    controller.markAsRead(item);
    Get.defaultDialog(
      title: item.title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        children: [
          const SizedBox(height: 8),
          Text(item.message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        onPressed: () => Get.back(),
        child: const Text("Tutup"),
      ),
    );
  }
}
