import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_colors.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:get/get.dart';

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
      borderSide: const BorderSide(color: AppColors.backgroundLight),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
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
                const Icon(Icons.music_note_rounded, size: 64, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'Welcome Back',
                  style: AppTextStyle.text2xlBold.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Sign in to continue',
                  style: AppTextStyle.textSmRegular.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  key: const ValueKey('auth.emailTextField'),
                  controller: controller.emailController,
                  style: AppTextStyle.textMdRegular.copyWith(color: AppColors.textPrimary),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: AppTextStyle.textSmRegular.copyWith(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface,
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
                  style: AppTextStyle.textMdRegular.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: AppTextStyle.textSmRegular.copyWith(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface,
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
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      key: const ValueKey('auth.errorText'),
                      controller.errorMessage.value,
                      style: AppTextStyle.textSmRegular.copyWith(color: AppColors.error),
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
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
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
                          ? const SizedBox(
                              key: ValueKey('auth.loginLoading'),
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                            )
                          : Text('Login', style: AppTextStyle.textMdBold.copyWith(color: AppColors.white)),
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
