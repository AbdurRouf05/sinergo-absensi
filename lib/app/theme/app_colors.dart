import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  AppColors._();

  // 1. Core Color Palette (Neo-Brutalism)
  static const Color primaryDeepNavy = Color(0xFF8B5CF6); // Bold Violet
  static const Color secondaryOceanBlue = Color(0xFF257ABA); // Keep for now
  static const Color tertiarySkyBlue = Color(0xFF81AFE0);
  static const Color accentWarningYellow = Color(0xFFFF6B6B); // Red for accent

  // Aliases for easier use
  static const Color primary = primaryDeepNavy;
  static const Color secondary = secondaryOceanBlue;
  static const Color tertiary = tertiarySkyBlue;
  static const Color accent = accentWarningYellow;

  // 2. Theme Adaptation Colors
  // Light Theme
  static const Color bgLight = Color(0xFFFEF9C3); // Pale Yellow
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White
  static const Color textLight = Color(0xFF000000); // Pure Black
  static const Color navbarLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFF000000); // Pure Black for borders

  // Dark Theme (Keep existing keys but update values if needed, usually Neo-Brutalism is light, but let's keep dark usable)
  static const Color bgDark = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color navbarDark = Color(0xFF000000);
  static const Color dividerDark = Color(0xFFFFFFFF);

  // 3. Semantic Colors (Status)
  static const Color success = Color(0xFF22C55E); // Green
  static const Color error = Color(0xFFFF6B6B); // Red
  static const Color warning = Color(0xFFFBD518);
  static const Color info = Color(0xFF3B82F6);
  static const Color locked = primaryDeepNavy;

  // Keep white and black for general usage
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Legacy/Common colors
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Attendance status mapping
  static const Color statusPresent = success;
  static const Color statusLate = warning;
  static const Color statusAbsent = error;
  static const Color statusLeave = Color(0xFF8B5CF6);
}
