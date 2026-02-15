import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../checkin_controller.dart';

class CheckInStatusCard extends GetView<CheckinController> {
  const CheckInStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isInside = controller.isInsideRadius.value;
      final distance = controller.currentDistance.value;
      // Handle uninitialized state (-1.0)
      final isLocating = distance < 0;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (isLocating)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                isInside ? Icons.check_circle : Icons.warning,
                color: isInside ? Colors.green : Colors.orange,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLocating
                        ? 'Mencari Lokasi...'
                        : (isInside
                            ? 'Di Dalam Area Presensi'
                            : 'Di Luar Area Presensi'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isLocating
                        ? 'Menunggu sinyal GPS...'
                        : 'Jarak: ${distance.toStringAsFixed(0)} meter',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),

                  // Debug: Match Percentage
                  if (!isLocating && distance >= 0)
                    Builder(builder: (_) {
                      final radius =
                          controller.selectedOffice.value?.radius ?? 50;
                      final percent = distance <= radius
                          ? 100
                          : ((radius / distance) * 100).clamp(0, 100);

                      return Text(
                        'Kecocokan: ${percent.toStringAsFixed(1)}% (Radius: ${radius.toStringAsFixed(0)}m)',
                        style: TextStyle(
                          color: percent == 100
                              ? Colors.green[700]
                              : Colors.orange[800],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
