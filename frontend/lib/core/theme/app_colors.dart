import 'package:flutter/material.dart';

/// Application color constants
/// Extracted from AppTheme for easier access
class AppColors {
  // Primary colors - Material 3 Design System
  static const Color primary = Color(0xFF6750A4); // Material Purple
  static const Color secondary = Color(0xFFE91E63); // Pink for favorites/premium
  static const Color tertiary = Color(0xFF00BCD4); // Teal for confirmations

  // Semantic colors
  static const Color error = Colors.red;
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Background colors
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Colors.black;
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF121212);

  // Text colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textDisabled = Colors.black38;
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;
  static const Color textDisabledDark = Colors.white38;

  // Divider and border colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      secondary,
      tertiary,
    ],
  );
}
