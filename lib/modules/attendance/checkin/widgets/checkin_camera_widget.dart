import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../checkin_controller.dart';

class CheckInCameraWidget extends GetView<CheckinController> {
  const CheckInCameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final photo = controller.capturedPhoto.value;
      final isCapturing = controller.isCapturingPhoto.value;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: photo != null ? Colors.green : Colors.grey[300]!,
            width: photo != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Photo Preview
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: photo != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(photo.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.person, size: 40, color: Colors.grey[400]),
            ),
            const SizedBox(width: 12),
            // Capture Button / Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo != null ? 'Foto Tersimpan ✓' : 'Foto Wajib *',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: photo != null ? Colors.green : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    photo != null
                        ? 'Ketuk untuk ambil ulang'
                        : 'Ambil foto selfie untuk absensi',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Capture/Retake Button
            isCapturing
                ? const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    onPressed: () => controller.capturePhoto(),
                    icon: Icon(
                      photo != null ? Icons.refresh : Icons.camera_alt,
                      color: Colors.blue[800],
                      size: 28,
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
