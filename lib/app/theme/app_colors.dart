import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  AppColors._();

  // 1. Core Color Palette (Brand Identity)
  static const Color primaryDeepNavy = Color(0xFF2E3D8A);
  static const Color secondaryOceanBlue = Color(0xFF257ABA);
  static const Color tertiarySkyBlue = Color(0xFF81AFE0);
  static const Color accentWarningYellow = Color(0xFFFBD518);

  // Aliases for easier use
  static const Color primary = primaryDeepNavy;
  static const Color secondary = secondaryOceanBlue;
  static const Color tertiary = tertiarySkyBlue;
  static const Color accent = accentWarningYellow;

  // 2. Theme Adaptation Colors
  // Light Theme
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFE8F1F8);
  static const Color textLight = primaryDeepNavy;
  static const Color navbarLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE2E8F0);

  // Dark Theme
  static const Color bgDark = Color(0xFF0F1629);
  static const Color surfaceDark = Color(0xFF252F4A);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color navbarDark = primaryDeepNavy;
  static const Color dividerDark = Color(0xFF334155);

  // 3. Semantic Colors (Status)
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBD518); // Pending Coord
  static const Color info = Color(0xFFF97316); // Pending Mgr
  static const Color locked = primaryDeepNavy; // Faktur

  // Keep white and black for general usage
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Legacy/Common colors - mapping to new palette where possible
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
  static const Color statusLeave = Color(0xFF8B5CF6); // Kept original for leave
}
