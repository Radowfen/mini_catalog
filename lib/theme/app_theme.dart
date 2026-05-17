import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Uygulama renk paleti.
///
/// Hem light hem dark mode için tek bir API:
/// `AppColors.of(context).background` gibi.
class AppColors {
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color elevatedSurface;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color accent;
  final Color accentSoft;
  final Color divider;
  final Color success;
  final Color favorite;
  final List<Color> bannerGradient;
  final List<Color> placeholderGradient;

  const AppColors._({
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.elevatedSurface,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.accent,
    required this.accentSoft,
    required this.divider,
    required this.success,
    required this.favorite,
    required this.bannerGradient,
    required this.placeholderGradient,
  });

  static const AppColors light = AppColors._(
    background: Color(0xFFFAFAFC),
    surface: Color(0xFFF1F1F4),
    cardBackground: Color(0xFFF4F4F7),
    elevatedSurface: Color(0xFFFFFFFF),
    primary: Color(0xFF0B0B0F),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF7A7A82),
    accent: Color(0xFF5E5CE6),
    accentSoft: Color(0xFFEAE9FF),
    divider: Color(0xFFE5E5EA),
    success: Color(0xFF34C759),
    favorite: Color(0xFFFF3B5C),
    bannerGradient: [
      Color(0xFF6D5BFF),
      Color(0xFF8E5BFF),
      Color(0xFFCB5BFF),
    ],
    placeholderGradient: [
      Color(0xFFDDE3FF),
      Color(0xFFEEE3FF),
    ],
  );

  static const AppColors dark = AppColors._(
    background: Color(0xFF0B0B0F),
    surface: Color(0xFF17171C),
    cardBackground: Color(0xFF1C1C22),
    elevatedSurface: Color(0xFF24242C),
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF0B0B0F),
    secondary: Color(0xFF9A9AA3),
    accent: Color(0xFF8B7CFF),
    accentSoft: Color(0xFF2A2841),
    divider: Color(0xFF2A2A33),
    success: Color(0xFF30D158),
    favorite: Color(0xFFFF5C7C),
    bannerGradient: [
      Color(0xFF4B3AFF),
      Color(0xFF7A3AFF),
      Color(0xFFB13AFF),
    ],
    placeholderGradient: [
      Color(0xFF24243C),
      Color(0xFF2E2440),
    ],
  );

  static AppColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}

class AppTheme {
  static ThemeData _build(AppColors c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.accent,
        brightness: brightness,
        primary: c.primary,
        onPrimary: c.onPrimary,
        surface: c.background,
        secondary: c.accent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: c.primary),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: c.primary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: c.primary,
          letterSpacing: -0.8,
          height: 1.05,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: c.primary,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: c.primary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: c.primary,
        ),
        bodyLarge: TextStyle(fontSize: 15, color: c.primary, height: 1.45),
        bodyMedium: TextStyle(fontSize: 14, color: c.secondary, height: 1.4),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize: const Size.fromHeight(54),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: c.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: TextStyle(color: c.secondary, fontSize: 15),
        prefixIconColor: c.secondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.accent, width: 1.4),
        ),
      ),
      dividerColor: c.divider,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.primary,
        contentTextStyle: TextStyle(
          color: c.onPrimary,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  static ThemeData light() => _build(AppColors.light, Brightness.light);
  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);
}
