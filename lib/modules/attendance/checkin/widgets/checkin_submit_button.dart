import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/modules/attendance/checkin/checkin_controller.dart';

class CheckInSubmitButton extends GetView<CheckinController> {
  const CheckInSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isInside = controller.isInsideRadius.value;
      final isLoading = controller.isLoading.value;
      final hasPhoto = controller.cameraManager.capturedPhoto.value != null;
      final isGanas = controller.ganasManager.isGanasActive.value;
      final hasGanasNotes = !isGanas || controller.ganasManager.isValid;

      final canSubmit = isInside && !isLoading && hasPhoto && hasGanasNotes;

      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: canSubmit ? () => controller.validateAndSubmit() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isCheckout.value
                ? Colors.orange[800]
                : Colors.blue[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  controller.isCheckout.value
                      ? 'PRESENSI PULANG SEKARANG'
                      : 'PRESENSI MASUK SEKARANG',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      );
    });
  }
}
