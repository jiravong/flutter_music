// lib/app/core/widgets/app_bar/core_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_colors.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:get/get.dart';

class CoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;

  const CoreAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null 
          ? Text(title!, style: AppTextStyle.textLgBold.copyWith(color: AppColors.textPrimary)) 
          : null,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent, // ทำให้โปร่งใสเพื่อโชว์สีพื้นหลังของ Scaffold
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: _buildLeading(context),
      actions: actions,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    // ถ้าสั่งให้โชว์ปุ่มย้อนกลับ และหน้าก่อนหน้านี้มีอยู่จริง
    if (showBackButton && Navigator.canPop(context)) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 20),
        onPressed: () => Get.back(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // ใช้ความสูงมาตรฐาน
}