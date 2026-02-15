import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import 'login_controller.dart';
import 'widgets/login_widgets.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                const LoginHeader(),
                const SizedBox(height: 48),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 8),
                _buildRememberMe(),
                const SizedBox(height: 24),
                Obx(() =>
                    LoginErrorCard(message: controller.errorMessage.value)),
                _buildLoginButton(),
                const SizedBox(height: 24),
                _buildVersionInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: controller.validateEmail,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'nama@perusahaan.com',
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        textInputAction: TextInputAction.done,
        validator: controller.validatePassword,
        onFieldSubmitted: (_) => controller.login(),
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: '••••••••',
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: controller.rememberMe.value,
            onChanged: (_) => controller.toggleRememberMe(),
            activeColor: AppColors.primary,
          ),
          GestureDetector(
            onTap: controller.toggleRememberMe,
            child: const Text(
              'Ingat saya',
              style: TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Masuk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: GestureDetector(
        onLongPress: () {
          Get.snackbar(
            'Debug Mode',
            'Logging in as Test Admin...',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          controller.debugLogin();
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'v0.1.0 (Long press for Debug Login)',
            style: TextStyle(fontSize: 12, color: AppColors.grey400),
          ),
        ),
      ),
    );
  }
}
