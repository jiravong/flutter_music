import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const ValueKey('auth.emailTextField'),
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('auth.passwordTextField'),
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.errorMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Text(
                key: const ValueKey('auth.errorText'),
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                key: const ValueKey('auth.loginButton'),
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
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
