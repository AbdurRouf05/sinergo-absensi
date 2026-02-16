import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/app/routes/app_routes.dart';
import '../widgets/overtime_claim_dialog.dart';

class CheckinDialogHelper {
  static bool isTestMode = false;

  static void showLoading() {
    if (Get.testMode) return;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static void closeLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  static void showSnackbar(String title, String message,
      {bool isError = false}) {
    if (Get.testMode || isTestMode) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccessDialog() {
    if (Get.testMode || isTestMode) return;
    Get.defaultDialog(
      title: "Berhasil",
      middleText: "Absensi berhasil disimpan!",
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // close dialog
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  static void showOvertimeTrapDialog({
    required Function(File?, String?) onClaimOvertime,
    required VoidCallback onRegularCheckout,
  }) {
    if (Get.testMode || isTestMode) return;
    Get.dialog(
      OvertimeClaimDialog(
        onConfirm: onClaimOvertime,
        onCancel: onRegularCheckout,
      ),
      barrierDismissible: false,
    );
  }

  static void showErrorDialog({
    required String title,
    required String message,
  }) {
    if (Get.testMode || isTestMode) return;
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      titleStyle:
          const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      onConfirm: () => Get.back(),
    );
  }
}
