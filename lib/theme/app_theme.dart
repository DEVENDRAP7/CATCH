import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Raw color tokens from the Catch visual design system.
class AppColors {
  AppColors._();

  static const Color tealLight = Color(0xFF147D89);
  static const Color tealDark = Color(0xFF4FC3D0);

  static const Color coralLight = Color(0xFFFF6B54);
  static const Color coralDark = Color(0xFFFF8570);

  static const Color sunLight = Color(0xFFFFB238);
  static const Color sunDark = Color(0xFFFFC966);

  static const Color sandLight = Color(0xFFFAF6EF);
  static const Color tealBlackDark = Color(0xFF0B1716);
}

/// Semantic accessors so screens never hardcode a light- or dark-only color.
extension CatchColors on ColorScheme {
  Color get accent => brightness == Brightness.dark ? AppColors.tealDark : AppColors.tealLight;
  Color get coral => brightness == Brightness.dark ? AppColors.coralDark : AppColors.coralLight;
  Color get sun => brightness == Brightness.dark ? AppColors.sunDark : AppColors.sunLight;
  Color get surfaceCard => brightness == Brightness.dark ? const Color(0xFF12211F) : Colors.white;
  Color get navBackground => brightness == Brightness.dark ? const Color(0xFF11201E) : Colors.white;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.tealDark : AppColors.tealLight,
      onPrimary: isDark ? const Color(0xFF06201F) : Colors.white,
      secondary: isDark ? AppColors.coralDark : AppColors.coralLight,
      onSecondary: Colors.white,
      error: const Color(0xFFE5484D),
      onError: Colors.white,
      surface: isDark ? AppColors.tealBlackDark : AppColors.sandLight,
      onSurface: isDark ? const Color(0xFFF3EFE6) : const Color(0xFF1B2422),
    );

    final materialBase = ThemeData(brightness: brightness, colorScheme: colorScheme).textTheme;
    final bodyTheme = GoogleFonts.manropeTextTheme(materialBase);
    final textTheme = bodyTheme
        .copyWith(
          displayLarge: GoogleFonts.fredoka(textStyle: bodyTheme.displayLarge, fontWeight: FontWeight.w600),
          displayMedium: GoogleFonts.fredoka(textStyle: bodyTheme.displayMedium, fontWeight: FontWeight.w600),
          displaySmall: GoogleFonts.fredoka(textStyle: bodyTheme.displaySmall, fontWeight: FontWeight.w600),
          headlineLarge: GoogleFonts.fredoka(textStyle: bodyTheme.headlineLarge, fontWeight: FontWeight.w600),
          headlineMedium: GoogleFonts.fredoka(textStyle: bodyTheme.headlineMedium, fontWeight: FontWeight.w600),
          headlineSmall: GoogleFonts.fredoka(textStyle: bodyTheme.headlineSmall, fontWeight: FontWeight.w600),
          titleLarge: GoogleFonts.fredoka(textStyle: bodyTheme.titleLarge, fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.fredoka(textStyle: bodyTheme.titleMedium, fontWeight: FontWeight.w600),
        )
        .apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      fontFamily: GoogleFonts.manrope().fontFamily,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
