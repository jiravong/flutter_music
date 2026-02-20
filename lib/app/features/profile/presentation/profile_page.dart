import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_colors.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/appbar/appbar.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/cached_image.dart';
import 'package:get/get.dart';

import '../../../core/translations/app_strings.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CoreAppBar(title: AppStrings.profileTitle.tr, showBackButton: true),
      body: Obx(
        () => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CoreImageNetwork(
                    imageUrl: controller.user.value?.imageProfile ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorWidget: Image.asset(
                      'assets/images/user.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${controller.user.value?.firstName ?? ''} ${controller.user.value?.lastName ?? ''}',
                  style: AppTextStyle.textLgBold,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.profileSettings.tr,
                style: AppTextStyle.textMdBold,
                textAlign: TextAlign.center,
              ),
              Expanded(child: SizedBox.shrink()),
              Center(
                child: GestureDetector(
                  onTap: () {
                    controller.logout();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppStrings.profileLogout.tr,
                      style: AppTextStyle.textMdRegular,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
