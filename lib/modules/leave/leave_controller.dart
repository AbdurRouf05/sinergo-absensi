import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sinergo_app/app/routes/app_routes.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/repositories/leave_repository.dart';
import 'package:sinergo_app/services/auth_service.dart';

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
  // GOLDEN CODE: SUBMIT LOGIC FIXED (FOCUS & NAV)
  // -------------------------------------------------------------------------
  Future<void> submit() async {
    // 1. Force Close Keyboard FIRST to prevent "ping-pong" effect
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(
        const Duration(milliseconds: 300)); // Wait for keyboard to close

    // 2. Validations
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

    // 3. Loading State
    isLoading.value = true; // Use reactive variable for UI loading state first
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

      // 4. API Execution
      await _leaveRepository.submitLeaveRequest(request,
          attachment: attachmentManager.selectedFile.value);

      // 5. Success Flow
      if (Get.isDialogOpen ?? false) Get.back(); // Close Loading Dialog

      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Pengajuan izin Anda telah dikirim."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // Determine navigation stack safety
                if (Get.isDialogOpen ?? false) {
                  Get.back(); // Close Success Dialog
                }
                clearForm();
                Get.offAllNamed(AppRoutes.home); // Reset to Home
              },
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      // 6. Error Flow
      if (Get.isDialogOpen ?? false) Get.back(); // Close Loading Dialog

      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Terjadi kesalahan: $e"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  // -------------------------------------------------------------------------
}
