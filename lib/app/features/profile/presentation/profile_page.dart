import 'package:flutter/material.dart';
import 'package:music_roop/app/core/themes/app_text_style.dart';
import 'package:music_roop/app/core/widgets/appbar/appbar.dart';
import 'package:music_roop/app/core/widgets/base_layout.dart';
import 'package:music_roop/app/core/widgets/cached_image.dart';
import 'package:get/get.dart';

import '../../../core/translations/app_strings.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CoreAppBar(
        title: AppStrings.profileTitle.tr,
        showBackButton: true,
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
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
                          errorWidget: Image.asset('assets/images/user.png'),
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
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            decoration: BoxDecoration(
                              color: context.theme.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: const SafeArea(
                              child: _LanguageSwitcher(),
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppStrings.profileLanguage.tr, style: AppTextStyle.textMdRegular),
                            Icon(Icons.language, color: context.theme.colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.logout();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.error,
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
          ],
        ),
      ),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale?.languageCode ?? 'en';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            AppStrings.profileLanguage.tr,
            style: AppTextStyle.textLgBold,
          ),
        ),
        const Divider(height: 1),
        _LanguageOption(
          label: AppStrings.profileLanguageTh.tr,
          isSelected: currentLocale == 'th',
          onTap: () {
            Get.updateLocale(const Locale('th', 'TH'));
            Get.back();
          },
        ),
        const Divider(height: 1),
        _LanguageOption(
          label: AppStrings.profileLanguageEn.tr,
          isSelected: currentLocale == 'en',
          onTap: () {
            Get.updateLocale(const Locale('en', 'US'));
            Get.back();
          },
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyle.textMdRegular),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                color: context.theme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
