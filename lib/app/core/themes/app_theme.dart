import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansThai',
      brightness: Brightness.light,
      extensions: const [
        AppColorsExtension(
          primary: AppColors.primary,
          primaryLight: AppColors.primaryLight,
          primaryDark: AppColors.primaryDark,
          transparent: AppColors.transparent,
          accent: AppColors.accent,
          white: AppColors.white,
          background: AppColors.background,
          backgroundDark: AppColors.backgroundDark,
          backgroundLight: AppColors.backgroundLight,
          backgroundHighlight: AppColors.backgroundHighlight,
          backgroundHighlight2: AppColors.backgroundHighlight2,
          surface: AppColors.surface,
          textPrimary: AppColors.textPrimary,
          textSecondary: AppColors.textSecondary,
          textLight: AppColors.textLight,
          success: AppColors.success,
          error: AppColors.error,
        ),
      ],
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.backgroundHighlight2,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9), // Light grayish-blue background
      textTheme: _textTheme(AppColors.backgroundHighlight2),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.backgroundHighlight2,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansThai',
      brightness: Brightness.dark,
      extensions: const [
        AppColorsExtension(
          primary: AppColors.primary,
          primaryLight: AppColors.primaryLight,
          primaryDark: AppColors.primaryDark,
          transparent: AppColors.transparent,
          accent: AppColors.accent,
          white: AppColors.white,
          background: AppColors.background,
          backgroundDark: AppColors.backgroundDark,
          backgroundLight: AppColors.backgroundLight,
          backgroundHighlight: AppColors.backgroundHighlight,
          backgroundHighlight2: AppColors.backgroundHighlight2,
          surface: AppColors.surface,
          textPrimary: AppColors.textPrimary,
          textSecondary: AppColors.textSecondary,
          textLight: AppColors.textLight,
          success: AppColors.success,
          error: AppColors.error,
        ),
      ],
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        onSecondary: AppColors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textTheme(AppColors.textPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static TextTheme _textTheme(Color defaultColor) {
    return TextTheme(
      displayLarge: AppTextStyle.text2xlBold.copyWith(color: defaultColor),
      displayMedium: AppTextStyle.textXlBold.copyWith(color: defaultColor),
      displaySmall: AppTextStyle.textLgBold.copyWith(color: defaultColor),
      headlineMedium: AppTextStyle.textMdBold.copyWith(color: defaultColor),
      headlineSmall: AppTextStyle.textSmBold.copyWith(color: defaultColor),
      titleLarge: AppTextStyle.textLgRegular.copyWith(color: defaultColor),
      titleMedium: AppTextStyle.textMdRegular.copyWith(color: defaultColor),
      titleSmall: AppTextStyle.textSmRegular.copyWith(color: defaultColor),
      bodyLarge: AppTextStyle.textMdRegular.copyWith(color: defaultColor),
      bodyMedium: AppTextStyle.textSmRegular.copyWith(color: defaultColor),
      bodySmall: AppTextStyle.textXsRegular.copyWith(color: defaultColor),
      labelLarge: AppTextStyle.textSmBold.copyWith(color: defaultColor),
      labelSmall: AppTextStyle.textXsBold.copyWith(color: defaultColor),
    );
  }
}
