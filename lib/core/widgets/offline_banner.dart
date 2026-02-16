import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/services/connectivity_service.dart';

class OfflineBanner extends GetView<ConnectivityService> {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // If controller not found, try to find it (safe lookup)
    if (!Get.isRegistered<ConnectivityService>()) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      if (controller.isOnline.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: const Color(0xFF424242), // Dark Grey
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              "Mode Offline: Menggunakan Database Lokal",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Spacer(),
            // Dismiss button (optional, but requested to be dismissible or push content)
            // Just a small close icon that could temporarily hide it?
            // For now, let's keep it persistent as "Mode Offline" until online.
            // User requested: "dismissible or ensure it pushes the body content down"
            // Since we put this in a Column/Stack, pushing down is better.
          ],
        ),
      );
    });
  }
}
