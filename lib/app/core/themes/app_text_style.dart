import 'package:flutter/material.dart';
import 'package:music_roop/app/core/themes/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static const _baseStyle = TextStyle(
    fontFamily: 'NotoSansThai',
    color: AppColors.textPrimary, // ใส่สี default ไว้ที่นี่
  );

  static TextStyle _createStyle(double fontSize, double height, FontWeight weight) {
    return _baseStyle.copyWith(
      fontSize: fontSize,
      height: height / fontSize,
      fontWeight: weight,
    );
  }

  // ตัวอย่างการทำ Label สั้นๆ ให้เรียกใช้ง่าย
  static TextStyle get h1 => text2xlBold;
  static TextStyle get body => textMdRegular;

  // --- ไล่ระดับขนาดตามที่คุณเขียนไว้ ---
  static final textXsRegular = _createStyle(12, 18, FontWeight.w400);
  static final textXsBold = _createStyle(12, 18, FontWeight.w700);

  static final textSmRegular = _createStyle(14, 20, FontWeight.w400);
  static final textSmBold = _createStyle(14, 20, FontWeight.w700);

  static final textMdRegular = _createStyle(16, 24, FontWeight.w400);
  static final textMdBold = _createStyle(16, 24, FontWeight.w700);

  static final textLgRegular = _createStyle(18, 26, FontWeight.w400);
  static final textLgBold = _createStyle(18, 26, FontWeight.w700);

  static final textXlRegular = _createStyle(20, 28, FontWeight.w400);
  static final textXlBold = _createStyle(20, 28, FontWeight.w700);

  static final text2xlRegular = _createStyle(24, 32, FontWeight.w400);
  static final text2xlBold = _createStyle(24, 32, FontWeight.w700);
  
  // ... (ใส่ตัวอื่นๆ ตามเดิมที่คุณมี)
}

// 🔥 เพิ่ม Extension เพื่อให้เปลี่ยนสีได้รวดเร็ว
extension TextStyleHelpers on TextStyle {
  TextStyle get primary => copyWith(color: AppColors.primary);
  TextStyle get secondary => copyWith(color: AppColors.textSecondary);
  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get error => copyWith(color: AppColors.error);
}