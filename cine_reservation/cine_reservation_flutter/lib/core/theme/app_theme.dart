import 'package:flutter/material.dart';

class AppColors {
  static const Color background   = Color(0xFF0D0A08);
  static const Color primary      = Color(0xFF4A3728);
  static const Color secondary    = Color(0xFF2C1810);
  static const Color accent       = Color(0xFF8B7355);
  static const Color textLight    = Color(0xFF9E9E8E);
  static const Color white        = Color(0xFFFFFFFF);
  static const Color error        = Color(0xFFCF6679);
  static const Color success      = Color(0xFF4CAF50);
  static const Color cardBg       = Color(0xFF1A1410);
  static const Color inputBg      = Color(0xFF1E1812);
  static const Color divider      = Color(0xFF2C2420);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.primary,
      surface: AppColors.cardBg,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.accent),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.textLight),
      hintStyle: const TextStyle(color: AppColors.textLight),
      prefixIconColor: AppColors.accent,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.white),
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.textLight),
      labelLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.divider),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
    ),
  );
}