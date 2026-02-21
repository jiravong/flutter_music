import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:music_roop/app/core/services/auth_service.dart';
import 'package:music_roop/app/core/storage/token_storage.dart';
import 'package:music_roop/app/features/auth/controllers/auth_controller.dart';
import 'package:music_roop/app/features/auth/presentation/login_page.dart';

import 'fakes.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
    
    final tokenStorage = FakeTokenStorage();
    Get.put<TokenStorage>(tokenStorage);
    Get.put<AuthService>(AuthService(tokenStorage));
    
    Get.put<AuthController>(TestAuthController(tokenStorage));
  });

  testWidgets('LoginPage renders test Keys', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: LoginPage()),
    );

    expect(find.byKey(const ValueKey('auth.emailTextField')), findsOneWidget);
    expect(find.byKey(const ValueKey('auth.passwordTextField')), findsOneWidget);
    expect(find.byKey(const ValueKey('auth.loginButton')), findsOneWidget);
  });
}
