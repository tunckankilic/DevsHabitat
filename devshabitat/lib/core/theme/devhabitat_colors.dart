import 'package:flutter/material.dart';

class DevHabitatColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryRed = Color(0xFFF44336);

  // Accent Colors
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color accentPurple = Color(0xFFBA68C8);
  static const Color accentGreen = Color(0xFF81C784);
  static const Color accentOrange = Color(0xFFFFB74D);
  static const Color accentRed = Color(0xFFE57373);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);

  // Background Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkBorder = Color(0xFF3D3D3D);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2196F3),
      Color(0xFF9C27B0),
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF121212),
      Color(0xFF1E1E1E),
    ],
  );

  // Skill Tag Colors
  static const Color skillTagBackground = Color(0xFF2D2D2D);
  static const Color skillTagBorder = Color(0xFF3D3D3D);
}
