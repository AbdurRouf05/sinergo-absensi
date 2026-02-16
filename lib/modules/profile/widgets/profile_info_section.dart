import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../profile_controller.dart';

class ProfileInfoSection extends GetView<ProfileController> {
  const ProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Column(
          children: [
            _buildInfoTile(
              icon: Icons.access_time_filled,
              title: "Jadwal Shift",
              valueObs: controller.shiftInfo,
              color: Colors.blue,
            ),
            const Divider(),
            _buildInfoTile(
              icon: Icons.location_on,
              title: "Lokasi Kantor",
              valueObs: controller.officeInfo,
              color: Colors.red,
            ),
            const Divider(),
            _buildInfoTile(
              icon: Icons.phone_android,
              title: "Device ID",
              value: controller.user.value?.registeredDeviceId ?? '-',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    String? value,
    RxString? valueObs,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
                if (valueObs != null)
                  Obx(() => Text(
                        valueObs.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey900,
                        ),
                      ))
                else
                  Text(
                    value ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
