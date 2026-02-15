import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../home_controller.dart';

class HomeDiagnostics extends GetView<HomeController> {
  const HomeDiagnostics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🛠️ Diagnostics (Phase 2)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(() => Text('WiFi: ${controller.wifiInfo.value}')),
          const SizedBox(height: 4),
          Obx(() => Text('GPS: ${controller.locationInfo.value}')),
          const SizedBox(height: 4),
          Obx(() => Text('Time: ${controller.timeStatus.value}')),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: controller.requestPermissions,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh & Check Perms'),
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}
