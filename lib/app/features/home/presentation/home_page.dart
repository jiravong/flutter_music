import 'package:flutter/material.dart';
import 'package:music_roop/app/core/themes/app_colors.dart';
import 'package:music_roop/app/core/themes/app_text_style.dart';
import 'package:music_roop/app/core/widgets/base_layout.dart';
import 'package:get/get.dart';

import '../../../core/translations/app_strings.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        titleTextStyle: AppTextStyle.textLgRegular,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/icon-app.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            Text(AppStrings.homeTitle.tr, style: AppTextStyle.textLgBold),
          ],
        ),
        backgroundColor: AppColors.transparent,
      ),
      // แสดงผลหน้าตาม Index ที่เลือก
      body: Center(child: Text(AppStrings.homeTitle.tr, style: AppTextStyle.textLgRegular)),
    );
  }
}
