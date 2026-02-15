import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/security_solution_card.dart';

/// [SecurityViolationView] - Full-screen block screen
///
/// Displayed when a security threat is detected.
/// User cannot navigate away - only option is to exit the app.
class SecurityViolationView extends StatelessWidget {
  const SecurityViolationView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    String threatType = 'Ancaman Keamanan';
    String threatMessage = 'Perangkat tidak aman terdeteksi';
    String solution = '';

    if (args != null && args is Map) {
      threatType = args['threatType'] ?? threatType;
      threatMessage = args['threatMessage'] ?? threatMessage;
      solution = args['solution'] ?? '';
    } else if (args is String) {
      threatMessage = args;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFB71C1C),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Shield Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),

                // Title
                const Text(
                  'SISTEM KEAMANAN TERPICU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Threat Type Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    threatType.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Threat Message
                Text(
                  threatMessage,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Warning Box
                _buildWarningBox(),
                const SizedBox(height: 24),

                // Solution Card (extracted widget)
                SecuritySolutionCard(solution: solution),
                const SizedBox(height: 48),

                // Exit Button
                _buildExitButton(),
                const SizedBox(height: 48),

                // Contact Info
                Text(
                  'Jika Anda yakin ini kesalahan,\nhubungi IT Support',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.amber.shade300, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Aplikasi tidak dapat berjalan pada perangkat yang tidak aman.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => exit(0),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFB71C1C),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.exit_to_app, size: 20),
            SizedBox(width: 8),
            Text(
              'KELUAR APLIKASI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
