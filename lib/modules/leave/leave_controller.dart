import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:attendance_fusion/app/routes/app_routes.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/repositories/leave_repository.dart';
import 'package:attendance_fusion/services/auth_service.dart';

import 'logic/leave_attachment_manager.dart';

class LeaveController extends GetxController {
  final ILeaveRepository _leaveRepository = Get.find<ILeaveRepository>();
  final IAuthService _authService = Get.find<IAuthService>();

  // Helpers
  final LeaveAttachmentManager attachmentManager = LeaveAttachmentManager();

  final RxBool isLoading = false.obs;

  // Form Fields
  final RxString selectedType = 'izin'.obs;
  final RxString reason = ''.obs;
  final Rx<DateTimeRange?> dateRange = Rx<DateTimeRange?>(null);

  // UI Controller
  final TextEditingController dateController = TextEditingController();

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }

  Future<void> pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      dateRange.value = picked;
      final fmt = DateFormat('dd MMM yyyy');
      dateController.text =
          "${fmt.format(picked.start)} - ${fmt.format(picked.end)}";
    }
  }

  // ============ HELPER ============
  void clearForm() {
    reason.value = '';
    dateRange.value = null;
    dateController.clear();
    selectedType.value = 'izin';
    attachmentManager.removeFile();
  }

  // ============ MAIN SUBMIT FUNCTION ============
  Future<void> submit() async {
    // 1. Validations
    if (reason.value.trim().isEmpty) {
      _showErrorDialog("Error", "Mohon isi alasan pengajuan!");
      return;
    }

    if (dateRange.value == null) {
      _showErrorDialog("Error", "Mohon pilih tanggal pengajuan!");
      return;
    }

    if (selectedType.value == 'sakit' &&
        attachmentManager.selectedFile.value == null) {
      _showErrorDialog("Error", "Tipe Sakit wajib melampirkan bukti!");
      return;
    }

    // 2. Loading State
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final user = _authService.currentUser.value;
      if (user == null) throw Exception('User belum login');

      final request = LeaveRequestLocal()
        ..userId = user.odId
        ..type = selectedType.value
        ..reason = reason.value.trim()
        ..startDate = dateRange.value!.start
        ..endDate = dateRange.value!.end
        ..status = 'pending'
        ..localAttachmentPath = attachmentManager.selectedFile.value?.path
        ..isSynced = false;

      // 3. API Execution
      await _leaveRepository.submitLeaveRequest(request,
          attachment: attachmentManager.selectedFile.value);

      // 4. Success Flow
      Get.back(); // Close Loading Dialog

      Get.defaultDialog(
          title: "Berhasil",
          middleText: "Pengajuan izin Anda telah dikirim.",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          buttonColor: Colors.green,
          barrierDismissible: false,
          onConfirm: () {
            clearForm();
            Get.back(); // Close dialog
            Get.offAllNamed(AppRoutes.home); // Navigate to Home
          });
    } catch (e) {
      // 5. Error Flow
      Get.back(); // Close Loading Dialog if open

      Get.defaultDialog(
        title: "Gagal",
        middleText: "Terjadi kesalahan: $e",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: () => Get.back(),
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        textConfirm: "OK",
        onConfirm: () => Get.back());
  }
}
