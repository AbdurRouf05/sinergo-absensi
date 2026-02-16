import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../home_controller.dart';

class HomeTodayStatus extends GetView<HomeController> {
  const HomeTodayStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Hari Ini',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              children: [
                _buildStatusItem(
                  label: 'Check In',
                  value: controller.checkInTimeStr.value,
                  icon: Icons.login,
                  isActive: controller.hasCheckedInToday.value,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.grey200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _buildStatusItem(
                  label: 'Check Out',
                  value: controller.checkOutTimeStr.value,
                  icon: Icons.logout,
                  isActive: controller.checkOutTimeStr.value != '--:--',
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: AppColors.grey200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _buildStatusItem(
                  label: 'Shift',
                  value: controller.currentShiftName.value == '-'
                      ? (controller.currentUser?.shiftOdId != null
                          ? 'Loading...'
                          : '-')
                      : controller.currentShiftName.value,
                  icon: Icons.access_time_filled,
                  isActive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required String label,
    required String value,
    required IconData icon,
    required bool isActive,
  }) {
    // split value if it contains parenthesis to make it multi-line
    String displayValue = value;
    String? subValue;

    // Check if it's the shift item (based on label or content) and has time info
    if (label == 'Shift' && value.contains('(') && value.contains(')')) {
      final parts = value.split('(');
      displayValue = parts[0].trim();
      subValue = "(${parts.length > 1 ? parts[1].trim() : ''}";
    }

    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.success : AppColors.grey400,
            size: 24,
          ),
          const SizedBox(height: 8),
          if (subValue != null) ...[
            Text(
              displayValue,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14, // Reduced from 16
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.grey900 : AppColors.grey400,
              ),
            ),
            Text(
              subValue,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.grey600 : AppColors.grey400,
              ),
            ),
          ] else
            Text(
              displayValue,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14, // Reduced from 16
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.grey900 : AppColors.grey400,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}
