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
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _statusController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _statusFade;

  @override
  void initState() {
    super.initState();

    // Logo: fade in + gentle scale up (0 → 1200ms) — SLOW & ELEGANT
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // Text: fade in + slide up (800ms delay, 900ms duration)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _titleFade = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Status text: fade in (1500ms delay, 700ms duration)
    _statusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _statusFade = CurvedAnimation(
      parent: _statusController,
      curve: Curves.easeIn,
    );

    // Stagger the animations — RELAXED TIMING
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    // Brief pause after native splash disappears
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Wait for logo to be mostly visible before showing text
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Wait for text to settle before status appears
    await Future.delayed(const Duration(milliseconds: 700));
    _statusController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Logo
        ScaleTransition(
          scale: _logoScale,
          child: FadeTransition(
            opacity: _logoFade,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/fusion_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Animated Title
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleFade,
            child: const Text(
              'ATTENDANCE',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Animated Subtitle (slightly delayed)
        FadeTransition(
          opacity: _subtitleFade,
          child: const Text(
            'F U S I O N',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: AppColors.white,
              letterSpacing: 10,
            ),
          ),
        ),
        const SizedBox(height: 56),

        // Status Section (fade in last)
        FadeTransition(
          opacity: _statusFade,
          child: Column(
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    controller.statusMessage.value,
                    key: ValueKey(controller.statusMessage.value),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w300,
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
