import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sinergo_app/data/models/notification_model.dart';
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
    Get.dialog(
      AlertDialog(
        title: Text(
          item.title,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(item.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt),
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black, // Black text on button
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black, width: 2.5),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text("Tutup",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
