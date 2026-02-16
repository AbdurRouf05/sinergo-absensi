import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/app/routes/app_routes.dart';

import '../../../../app/theme/app_colors.dart';
import '../profile_controller.dart';

class ProfileActionSection extends GetView<ProfileController> {
  const ProfileActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Admin Check
          Obx(() {
            if (controller.user.value?.role == UserRole.admin) {
              return Column(
                children: [
                  _buildActionTile(
                    icon: Icons.admin_panel_settings,
                    title: "Menu Admin",
                    onTap: () => Get.toNamed(AppRoutes.adminDashboard),
                    colorOverride: Colors.deepPurple,
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          _buildActionTile(
            icon: Icons.lock_outline,
            title: "Ganti Password",
            onTap: controller.changePassword,
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.logout,
            title: "Keluar Aplikasi",
            onTap: () {
              Get.defaultDialog(
                title: "Konfirmasi Keluar",
                middleText: "Apakah Anda yakin ingin keluar dari aplikasi?",
                textConfirm: "Ya, Keluar",
                textCancel: "Batal",
                confirmTextColor: Colors.white,
                buttonColor: AppColors.error,
                cancelTextColor: AppColors.grey800,
                onConfirm: () {
                  Get.back(); // Close dialog
                  controller.logout();
                },
              );
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    Color? colorOverride,
  }) {
    // Color variable removed as it was unused

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
