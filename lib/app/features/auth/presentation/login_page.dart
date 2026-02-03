import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

// Basic login form.
//
// UI reads state from AuthController via Obx:
// - isLoading: disables button and shows spinner
// - errorMessage: shows errors
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Binding provides AuthController for this route.
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            Obx(() {
              // Render error label when controller reports an error.
              if (controller.errorMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        // Trigger login flow in controller.
                        controller.login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      },
                child: controller.isLoading.value
                    ? const SizedBox(
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
