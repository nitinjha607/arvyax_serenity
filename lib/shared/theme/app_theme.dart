import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        primary: AppColors.lightPrimary,
        onBackground: AppColors.lightOnBackground,
        onSurface: AppColors.lightOnSurface,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.lightOnBackground),
        bodyLarge: GoogleFonts.inter(color: AppColors.lightOnBackground),
        bodyMedium: GoogleFonts.inter(color: AppColors.lightOnSurface),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        primary: AppColors.darkPrimary,
        onBackground: AppColors.darkOnBackground,
        onSurface: AppColors.darkOnSurface,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.darkOnBackground),
        bodyLarge: GoogleFonts.inter(color: AppColors.darkOnBackground),
        bodyMedium: GoogleFonts.inter(color: AppColors.darkOnSurface),
      ),
    );
  }
}
