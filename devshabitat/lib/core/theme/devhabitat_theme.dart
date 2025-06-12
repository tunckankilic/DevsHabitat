import 'package:flutter/material.dart';
import 'dev_habitat_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DevHabitatTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: DevHabitatColors.primary,
        secondary: DevHabitatColors.secondary,
        background: DevHabitatColors.darkBackground,
        surface: DevHabitatColors.darkSurface,
        error: DevHabitatColors.error,
      ),
      scaffoldBackgroundColor: DevHabitatColors.darkBackground,
      cardTheme: CardThemeData(
        color: DevHabitatColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DevHabitatColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: DevHabitatColors.textPrimary),
        titleTextStyle: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: DevHabitatColors.textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: DevHabitatColors.textTertiary,
          fontSize: 12,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DevHabitatColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.darkBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.error,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DevHabitatColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DevHabitatColors.primary,
          side: BorderSide(color: DevHabitatColors.primary),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DevHabitatColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: DevHabitatColors.textPrimary,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: DevHabitatColors.darkBorder,
        thickness: 1,
        space: 24,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DevHabitatColors.darkBackground,
        selectedItemColor: DevHabitatColors.primary,
        unselectedItemColor: DevHabitatColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DevHabitatColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DevHabitatColors.darkCard,
        contentTextStyle: TextStyle(color: DevHabitatColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DevHabitatColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: DevHabitatColors.textSecondary,
          fontSize: 16,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: DevHabitatColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 14,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: DevHabitatColors.darkCard,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: DevHabitatColors.textPrimary,
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: DevHabitatColors.primary,
        secondary: DevHabitatColors.secondary,
        background: DevHabitatColors.lightBackground,
        surface: DevHabitatColors.lightSurface,
        error: DevHabitatColors.error,
      ),
      scaffoldBackgroundColor: DevHabitatColors.lightBackground,
      cardTheme: CardThemeData(
        color: DevHabitatColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: DevHabitatColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DevHabitatColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: DevHabitatColors.textDark),
        titleTextStyle: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: DevHabitatColors.textGray,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: DevHabitatColors.textGray.withOpacity(0.7),
          fontSize: 12,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DevHabitatColors.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.lightBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.lightBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: DevHabitatColors.error,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DevHabitatColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DevHabitatColors.primary,
          side: BorderSide(color: DevHabitatColors.primary),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DevHabitatColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: DevHabitatColors.textDark,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: DevHabitatColors.lightBorder,
        thickness: 1,
        space: 24,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DevHabitatColors.lightBackground,
        selectedItemColor: DevHabitatColors.primary,
        unselectedItemColor: DevHabitatColors.textGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DevHabitatColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DevHabitatColors.lightCard,
        contentTextStyle: TextStyle(color: DevHabitatColors.textDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DevHabitatColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: DevHabitatColors.textGray,
          fontSize: 16,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: DevHabitatColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 14,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: DevHabitatColors.lightCard,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: DevHabitatColors.textDark,
          fontSize: 12,
        ),
      ),
    );
  }

  // Glass Effect Decorations
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: DevHabitatColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DevHabitatColors.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DevHabitatColors.shadowDark,
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      );

  static BoxDecoration get glassCardDecoration => BoxDecoration(
        color: DevHabitatColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DevHabitatColors.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DevHabitatColors.shadowLight,
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      );

  // Neumorphism Decorations
  static BoxDecoration get neumorphismDecoration => BoxDecoration(
        color: DevHabitatColors.darkBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: DevHabitatColors.shadowDark,
            offset: Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: DevHabitatColors.shadowLight,
            offset: Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      );

  // Custom Text Styles
  static TextStyle get codeTextStyle => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        color: DevHabitatColors.textPrimary,
        backgroundColor: DevHabitatColors.codeBackground,
      );

  static TextStyle get skillTagTextStyle => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: DevHabitatColors.primary,
      );

  static TextStyle get usernameTextStyle => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: DevHabitatColors.textPrimary,
      );

  static TextStyle get statusTextStyle => GoogleFonts.roboto(
        fontSize: 12,
        color: DevHabitatColors.textSecondary,
      );

  static TextStyle get titleLarge => GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get titleMedium => GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get titleSmall => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w200,
        color: Colors.white,
      );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      );

  static TextStyle get bodySmall => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      );

  static TextStyle get labelLarge => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  static TextStyle get labelMedium => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  static TextStyle get labelSmall => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  // Headline Styles
  static TextStyle get headlineLarge => GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: Colors.white,
      );

  static TextStyle get headlineMedium => GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: Colors.white,
      );

  static TextStyle get headlineSmall => GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: Colors.white,
      );
}
