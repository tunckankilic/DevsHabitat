import 'package:devshabitat/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DevHabitatTheme {
  // Glass Effect Decoration
  static BoxDecoration glassDecoration({
    Color? background,
    Color? border,
    double borderRadius = 16.0,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: background ?? DevHabitatColors.glassBackground,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: border ?? DevHabitatColors.glassBorder,
        width: 1.0,
      ),
      boxShadow: shadows ??
          [
            BoxShadow(
              color: DevHabitatColors.shadowMedium,
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
    );
  }

  // Neumorphism Effect
  static BoxDecoration neumorphismDecoration({
    required bool isDark,
    bool isPressed = false,
    double borderRadius = 16.0,
  }) {
    return BoxDecoration(
      color: isDark ? DevHabitatColors.darkCard : DevHabitatColors.lightCard,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: isDark
                    ? Colors.black.withAlpha(77)
                    : Colors.black.withAlpha(26),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(2, 2),
              ),
            ]
          : [
              BoxShadow(
                color: isDark
                    ? Colors.black.withAlpha(128)
                    : Colors.black.withAlpha(26),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(8, 8),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.white.withAlpha(13)
                    : Colors.white.withAlpha(204),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(-8, -8),
              ),
            ],
    );
  }

  // Custom Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static const titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DevHabitatColors.darkBackground,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: DevHabitatColors.primaryBlue,
        secondary: DevHabitatColors.primaryPurple,
        tertiary: DevHabitatColors.primaryGreen,
        surface: DevHabitatColors.darkSurface,
        background: DevHabitatColors.darkBackground,
        error: DevHabitatColors.error,
        onPrimary: DevHabitatColors.textPrimary,
        onSecondary: DevHabitatColors.textPrimary,
        onSurface: DevHabitatColors.textPrimary,
        onBackground: DevHabitatColors.textPrimary,
        onError: DevHabitatColors.textPrimary,
        outline: DevHabitatColors.darkBorder,
        surfaceVariant: DevHabitatColors.darkCard,
        onSurfaceVariant: DevHabitatColors.textSecondary,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: DevHabitatColors.textPrimary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: DevHabitatColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DevHabitatColors.primaryBlue,
          foregroundColor: DevHabitatColors.textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DevHabitatColors.primaryBlue,
          side: const BorderSide(
            color: DevHabitatColors.primaryBlue,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DevHabitatColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DevHabitatColors.darkCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DevHabitatColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: DevHabitatColors.error,
            width: 1,
          ),
        ),
        labelStyle: const TextStyle(
          color: DevHabitatColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: DevHabitatColors.textTertiary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DevHabitatColors.darkSurface,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: DevHabitatColors.primaryBlue,
        unselectedItemColor: DevHabitatColors.textTertiary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DevHabitatColors.primaryBlue,
        foregroundColor: DevHabitatColors.textPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Typography
      textTheme: const TextTheme(
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
      ).apply(
        bodyColor: DevHabitatColors.textPrimary,
        displayColor: DevHabitatColors.textPrimary,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: DevHabitatColors.textSecondary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: DevHabitatColors.darkBorder,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: DevHabitatColors.skillTagBackground,
        deleteIconColor: DevHabitatColors.textSecondary,
        disabledColor: DevHabitatColors.darkBorder,
        selectedColor: DevHabitatColors.primaryBlue,
        secondarySelectedColor: DevHabitatColors.primaryPurple,
        labelStyle: const TextStyle(
          color: DevHabitatColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: DevHabitatColors.skillTagBorder,
            width: 1,
          ),
        ),
      ),
    );
  }

  // Light Theme (Optional - Focus on Dark for DevHabitat)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: DevHabitatColors.lightBackground,

      colorScheme: const ColorScheme.light(
        primary: DevHabitatColors.primaryBlue,
        secondary: DevHabitatColors.primaryPurple,
        tertiary: DevHabitatColors.primaryGreen,
        surface: DevHabitatColors.lightSurface,
        background: DevHabitatColors.lightBackground,
        error: DevHabitatColors.error,
        onPrimary: DevHabitatColors.textPrimary,
        onSecondary: DevHabitatColors.textPrimary,
        onSurface: DevHabitatColors.textDark,
        onBackground: DevHabitatColors.textDark,
        onError: DevHabitatColors.textPrimary,
        outline: DevHabitatColors.lightBorder,
        surfaceVariant: DevHabitatColors.lightCard,
        onSurfaceVariant: DevHabitatColors.textGray,
      ),

      // Similar structure as dark theme but with light colors
      // Implementation truncated for brevity - focus on dark theme
    );
  }
}
