import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/app/theme/app_colors.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/repositories/attendance_repository.dart';
import 'package:attendance_fusion/app/routes/app_routes.dart';
import 'package:attendance_fusion/services/sync_service.dart';

enum AttendanceState { notCheckedIn, checkedIn, completed }

class AttendanceController extends GetxController {
  final Logger _logger = Logger();
  final IAttendanceRepository _attendanceRepository =
      Get.find<IAttendanceRepository>();
  // Inject Sync Service for Posko updates
  final ISyncService _syncService = Get.find<ISyncService>();

  // Use Rx<AttendanceLocal?> to track the actual object
  final Rx<AttendanceLocal?> todayAttendance = Rx<AttendanceLocal?>(null);

  // Derived State
  final Rx<AttendanceState> currentState = AttendanceState.notCheckedIn.obs;

  @override
  void onInit() {
    super.onInit();
    checkDailyStatus();
  }

  @override
  void onReady() {
    super.onReady();
    // Force refresh master data (Offices/Posko) so they appear in dropdown
    _refreshMasterData();
  }

  Future<void> _refreshMasterData() async {
    try {
      await _syncService.syncMasterData();
      _logger.i("Master Data synced in AttendanceController");
    } catch (e) {
      _logger.w("Failed to background sync master data: $e");
    }
  }

  /// Step A: Cek Status Harian
  Future<void> checkDailyStatus() async {
    try {
      final attendance = await _attendanceRepository.getTodayAttendance();
      todayAttendance.value = attendance;
      _determineState();
    } catch (e) {
      _logger.e('Failed to check daily status', error: e);
    }
  }

  /// Step B: Tentukan State UI
  void _determineState() {
    final att = todayAttendance.value;

    if (att == null) {
      currentState.value = AttendanceState.notCheckedIn;
    } else if (att.checkOutTime == null) {
      currentState.value = AttendanceState.checkedIn; // Needs Check-Out
    } else {
      currentState.value = AttendanceState.completed; // Done for the day
    }

    _logger.i('Attendance State Updated: ${currentState.value}');
  }

  // Loading state for Anti-Freeze
  final RxBool isLoading = false.obs;

  /// Action Handle
  void onPresensiButtonPressed() {
    if (isLoading.value) return;
    isLoading.value = true;

    checkDailyStatus().then((_) {
      isLoading.value = false;
      // 1. CEK STATUS COMPLETED DULUAN (Prioritas Mutlak)
      if (currentState.value == AttendanceState.completed) {
        // USE DIALOG (Lebih Stabil daripada Snackbar)
        Get.defaultDialog(
          title: "Selesai",
          middleText:
              "Anda sudah menuntaskan absensi hari ini.\nSampai jumpa besok!",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(), // Tutup dialog
          barrierDismissible: false,
          buttonColor: AppColors.success,
        );
        return; // Stop di sini
      }

      switch (currentState.value) {
        case AttendanceState.notCheckedIn:
          Get.toNamed(AppRoutes.checkin); // Logic Masuk (Create) exists there
          break;
        case AttendanceState.checkedIn:
          // Navigate to Checkin View with isCheckout: true
          Get.toNamed(AppRoutes.checkin, arguments: {'isCheckout': true});
          break;
        case AttendanceState.completed:
          // Feedback UX: Tampilkan pesan ramah
          Get.snackbar(
            'Absensi Selesai',
            'Absensi hari ini tuntas. Selamat beristirahat!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          break;
      }
    });
  }

  // NOTE: The actual "Execution" (Create/Update) is currently inside `CheckinController`'s `validateAndSubmit`.
  // We need to update `CheckinController` to handle the `isCheckout` flag to call Update instead of Create.
}
