import 'package:flutter/material.dart';
import 'package:music_roop/app/core/themes/app_text_style.dart';
import 'package:music_roop/app/core/widgets/base_layout.dart';
import 'package:get/get.dart';

import '../../../core/translations/app_strings.dart';
import '../controllers/auth_controller.dart';

// Basic login form.
//
// UI reads state from AuthController via Obx:
// - isLoading: disables button and shows spinner
// - errorMessage: shows errors
class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: context.theme.colorScheme.onSurface.withValues(alpha:0.1)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: context.theme.colorScheme.primary, width: 2),
    );

    return BaseScaffold(
      // backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.music_note_rounded, size: 64, color: context.theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  AppStrings.authWelcomeBack.tr,
                  style: AppTextStyle.text2xlBold.copyWith(color: context.theme.colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.authSignInToContinue.tr,
                  style: AppTextStyle.textSmRegular.copyWith(color: context.theme.colorScheme.onSurface.withValues(alpha:0.6)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  key: const ValueKey('auth.emailTextField'),
                  controller: controller.emailController,
                  style: AppTextStyle.textMdRegular.copyWith(color: context.theme.colorScheme.onSurface),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.authEmail.tr,
                    labelStyle: AppTextStyle.textSmRegular.copyWith(color: context.theme.colorScheme.onSurface.withValues(alpha:0.6)),
                    prefixIcon: Icon(Icons.email_outlined, color: context.theme.colorScheme.onSurface.withValues(alpha:0.6)),
                    filled: true,
                    fillColor: context.theme.colorScheme.surface,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: focusedBorder,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('auth.passwordTextField'),
                  controller: controller.passwordController,
                  obscureText: true,
                  style: AppTextStyle.textMdRegular.copyWith(color: context.theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: AppStrings.authPassword.tr,
                    labelStyle: AppTextStyle.textSmRegular.copyWith(color: context.theme.colorScheme.onSurface.withValues(alpha:0.6)),
                    prefixIcon: Icon(Icons.lock_outline, color: context.theme.colorScheme.onSurface.withValues(alpha:0.6)),
                    filled: true,
                    fillColor: context.theme.colorScheme.surface,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: focusedBorder,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.error.withValues(alpha:0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.theme.colorScheme.error.withValues(alpha:0.4)),
                    ),
                    child: Text(
                      key: const ValueKey('auth.errorText'),
                      controller.errorMessage.value,
                      style: AppTextStyle.textSmRegular.copyWith(color: context.theme.colorScheme.error),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Obx(() {
                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      key: const ValueKey('auth.loginButton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.colorScheme.primary,
                        foregroundColor: context.theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.login(
                                email: controller.emailController.text.trim(),
                                password: controller.passwordController.text,
                              );
                            },
                      child: controller.isLoading.value
                          ? SizedBox(
                              key: const ValueKey('auth.loginLoading'),
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: context.theme.colorScheme.onPrimary),
                            )
                          : Text(AppStrings.authLogin.tr, style: AppTextStyle.textMdBold.copyWith(color: context.theme.colorScheme.onPrimary)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
