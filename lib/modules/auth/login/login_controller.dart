import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../core/errors/app_exceptions.dart';

/// LoginController - Handles user authentication
class LoginController extends GetxController {
  final IAuthService _authService;

  LoginController({
    IAuthService? authService,
  }) : _authService = authService ?? Get.find<IAuthService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool rememberMe = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  /// Perform login
  Future<void> login() async {
    // Clear previous error
    errorMessage.value = '';

    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // Success - navigate to home
      Get.offAllNamed(AppRoutes.home);
    } on DeviceBindingException catch (e) {
      // Device blocked
      errorMessage.value = e.message;
      _showDeviceBlockedDialog();
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Show device blocked dialog
  void _showDeviceBlockedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 8),
            Text('Perangkat Diblokir'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(errorMessage.value),
            const SizedBox(height: 16),
            const Text(
              'Akun Anda sudah terdaftar dengan perangkat lain. '
              'Hubungi HR untuk melakukan reset perangkat.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// DEBUG LOGIN
  Future<void> debugLogin() async {
    isLoading.value = true;
    try {
      await _authService.debugLogin();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = 'Debug Login Failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
