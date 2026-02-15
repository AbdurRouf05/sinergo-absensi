import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi Pulang'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(),
            const SizedBox(height: 20),

            // Optional Photo Capture
            _buildOptionalPhotoCapture(),
            const SizedBox(height: 20),

            // Dev Mode Indicator
            _buildDevModeIndicator(),

            const Spacer(),

            // Checkout Button
            _buildCheckoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Obx(() {
      final attendance = controller.todayAttendance.value;
      final hasCheckedIn = attendance != null;
      final hasCheckedOut = attendance?.checkOutTime != null;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hasCheckedOut
              ? Colors.green[50]
              : (hasCheckedIn ? Colors.blue[50] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasCheckedOut
                ? Colors.green
                : (hasCheckedIn ? Colors.blue : Colors.grey),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasCheckedOut
                  ? Icons.check_circle
                  : (hasCheckedIn ? Icons.login : Icons.warning),
              size: 48,
              color: hasCheckedOut
                  ? Colors.green
                  : (hasCheckedIn ? Colors.blue : Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              hasCheckedOut
                  ? 'Sudah Check-Out'
                  : (hasCheckedIn ? 'Siap Check-Out' : 'Belum Check-In'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: hasCheckedOut
                    ? Colors.green[800]
                    : (hasCheckedIn ? Colors.blue[800] : Colors.grey[700]),
              ),
            ),
            if (hasCheckedIn && !hasCheckedOut) ...[
              const SizedBox(height: 8),
              Text(
                'Check-in: ${_formatTime(attendance.checkInTime)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            if (hasCheckedOut) ...[
              const SizedBox(height: 8),
              Text(
                'Check-out: ${_formatTime(attendance!.checkOutTime!)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildOptionalPhotoCapture() {
    return Obx(() {
      final photo = controller.capturedPhoto.value;
      final isCapturing = controller.isCapturingPhoto.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
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
            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo != null ? 'Foto Tersimpan' : 'Foto (Opsional)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    photo != null
                        ? 'Ketuk untuk ambil ulang'
                        : 'Ambil foto untuk check-out',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Capture button
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

  Widget _buildDevModeIndicator() {
    return Obx(() {
      if (!controller.skipValidation.value) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.developer_mode, size: 18, color: Colors.orange[800]),
            const SizedBox(width: 8),
            Text(
              'DEV MODE: GPS/WiFi validation skipped',
              style: TextStyle(fontSize: 12, color: Colors.orange[800]),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCheckoutButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final attendance = controller.todayAttendance.value;
      final canCheckout = attendance != null && attendance.checkOutTime == null;

      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: (canCheckout && !isLoading)
              ? () => controller.validateAndSubmit()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'PRESENSI PULANG SEKARANG',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      );
    });
  }
}
