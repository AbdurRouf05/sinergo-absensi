import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(child: Center(child: Obx(() => _buildContent()))),
    );
  }

  Widget _buildContent() {
    if (controller.isDeviceBlocked.value) return _buildBlockedDevice();
    if (controller.hasError.value) return _buildError();
    return const _AnimatedSplashBody();
  }

  Widget _buildBlockedDevice() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.block, size: 64, color: AppColors.white),
          ),
          const SizedBox(height: 32),
          const Text(
            'Perangkat Tidak Terdaftar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.support_agent, size: 32, color: AppColors.white),
                SizedBox(height: 8),
                Text(
                  'Hubungi HR untuk reset perangkat',
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.white),
          const SizedBox(height: 24),
          const Text(
            'Terjadi Kesalahan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: controller.retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated splash body with logo fade-in, scale, and text reveal.
class _AnimatedSplashBody extends StatefulWidget {
  const _AnimatedSplashBody();

  @override
  State<_AnimatedSplashBody> createState() => _AnimatedSplashBodyState();
}

class _AnimatedSplashBodyState extends State<_AnimatedSplashBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Small delay to let UI settle
    await Future.delayed(const Duration(milliseconds: 100));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // FIXED SIMPLE LOGO (MATCHING LOGIN VIEW) + ANIMATED
        ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 180, // Slightly larger for better visibility
              height: 180,
              decoration: BoxDecoration(
                // Clean shadow, no border radius clipping to show full logo shape
                shape: BoxShape.circle,
                color: Colors.white, // White background for Blue Logo
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32), // Padding to frame the logo
              child: Image.asset(
                'assets/images/image.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        const SizedBox(height: 60),

        // Status Section
        FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    controller.statusMessage.value,
                    key: ValueKey(controller.statusMessage.value),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
