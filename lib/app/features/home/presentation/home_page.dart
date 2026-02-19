import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // แสดงผลหน้าตาม Index ที่เลือก
      body: Center(child: Text('Home', style: AppTextStyle.textLgRegular)),
    );
  }
}