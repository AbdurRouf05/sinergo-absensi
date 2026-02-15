import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';

class ChangePasswordDialog extends StatelessWidget {
  final IAuthService authService;
  final UserLocal currentUser;

  ChangePasswordDialog(
      {super.key, required this.authService, required this.currentUser});

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  final Logger _logger = Logger();

  Future<void> _handleSubmit() async {
    final oldPass = oldPassController.text;
    final newPass = newPassController.text;
    final confirmPass = confirmPassController.text;

    // Validation
    if (oldPass.isEmpty) {
      _showSnackbar("Validasi Gagal", "Password lama wajib diisi.");
      return;
    }
    if (newPass != confirmPass) {
      _showSnackbar(
          "Validasi Gagal", "Password baru dan konfirmasi tidak cocok.");
      return;
    }
    if (newPass.length < 8) {
      _showSnackbar("Validasi Gagal", "Password baru minimal 8 karakter.");
      return;
    }

    // Loading
    Get.dialog(
      const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      barrierDismissible: false,
    );

    try {
      // Execute
      await authService.pb
          .collection('users')
          .authWithPassword(currentUser.email, oldPass);

      await authService.pb.collection('users').update(
        currentUser.odId,
        body: {
          'password': newPass,
          'passwordConfirm': confirmPass,
          'oldPassword': oldPass,
        },
      );

      Get.back(); // Close Loading

      // Success
      oldPassController.clear();
      newPassController.clear();
      confirmPassController.clear();

      Get.defaultDialog(
        title: "Sukses",
        middleText: "Password berhasil diperbarui!",
        textConfirm: "OK",
        buttonColor: Colors.green,
        confirmTextColor: Colors.white,
        barrierDismissible: false,
        onConfirm: () {
          Get.back(); // Close Success
          Get.back(); // Close Form
        },
      );
    } catch (e) {
      Get.back(); // Close Loading
      _logger.e("Change Password Error", error: e);

      Get.defaultDialog(
        title: "Gagal",
        middleText:
            "Gagal mengubah password. Pastikan password lama benar.\n\nDetail: $e",
        textConfirm: "OK",
        buttonColor: Colors.red,
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    }
  }

  void _showSnackbar(String title, String msg) {
    Get.snackbar(title, msg,
        backgroundColor: Colors.orange, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ganti Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password Lama', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password Baru', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
