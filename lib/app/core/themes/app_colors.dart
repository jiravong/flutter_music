import 'package:flutter/material.dart';

class AppColors {
  // Primary Blue
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF93C5FD);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color transparent = Colors.transparent;

  // Accent
  static const Color accent = Color(0xFF06B6D4);
  static const Color white = Colors.white;

  // Background — โทนเข้มสไตล์แอปเพลง
  static const Color background = Color.fromARGB(255, 31, 48, 88);
  static const Color backgroundDark = Color(0xFF020617);
  static const Color backgroundLight = Color.fromARGB(255, 52, 81, 126);
  static const Color backgroundHighlight = Color(0xFF1E293B);
  static const Color backgroundHighlight2 = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textLight = Colors.white;

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
}
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color transparent;
  final Color accent;
  final Color white;
  final Color background;
  final Color backgroundDark;
  final Color backgroundLight;
  final Color backgroundHighlight;
  final Color backgroundHighlight2;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLight;
  final Color success;
  final Color error;

  const AppColorsExtension({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.transparent,
    required this.accent,
    required this.white,
    required this.background,
    required this.backgroundDark,
    required this.backgroundLight,
    required this.backgroundHighlight,
    required this.backgroundHighlight2,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLight,
    required this.success,
    required this.error,
  });

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? transparent,
    Color? accent,
    Color? white,
    Color? background,
    Color? backgroundDark,
    Color? backgroundLight,
    Color? backgroundHighlight,
    Color? backgroundHighlight2,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textLight,
    Color? success,
    Color? error,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      transparent: transparent ?? this.transparent,
      accent: accent ?? this.accent,
      white: white ?? this.white,
      background: background ?? this.background,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundHighlight: backgroundHighlight ?? this.backgroundHighlight,
      backgroundHighlight2: backgroundHighlight2 ?? this.backgroundHighlight2,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textLight: textLight ?? this.textLight,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }

  @override
  AppColorsExtension lerp(covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      white: Color.lerp(white, other.white, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      backgroundHighlight: Color.lerp(backgroundHighlight, other.backgroundHighlight, t)!,
      backgroundHighlight2: Color.lerp(backgroundHighlight2, other.backgroundHighlight2, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
