import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../checkin_controller.dart';

class CheckInTimeDisplay extends GetView<CheckinController> {
  const CheckInTimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final timeStr = controller.formattedTime.value;
      if (timeStr.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              timeStr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    });
  }
}
