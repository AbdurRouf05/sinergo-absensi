import 'package:get/get.dart';
import 'dart:io';

class OvertimeManager extends GetxController {
  final isOvertimeActive = false.obs;
  final overtimeNote = ''.obs;
  final capturedPhoto = Rxn<File>();

  // Threshold in minutes
  static const int thresholdMinutes = 60;

  bool get isValid =>
      overtimeNote.value.trim().length >= 5 && capturedPhoto.value != null;

  void reset() {
    isOvertimeActive.value = false;
    overtimeNote.value = '';
    capturedPhoto.value = null;
  }

  /// Checks if current time is > 60 mins from shift end
  bool isThresholdReached(DateTime currentTime, DateTime shiftEndTime) {
    final diff = currentTime.difference(shiftEndTime).inMinutes;
    return diff > thresholdMinutes;
  }

  /// Calculates duration if overtime is approved
  int calculateOvertimeMinutes(DateTime currentTime, DateTime shiftEndTime) {
    return currentTime.difference(shiftEndTime).inMinutes;
  }
}
