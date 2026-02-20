// Basic smoke test for app boot.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_music_clean_getx/app/core/services/auth_service.dart';
import 'package:flutter_music_clean_getx/app/core/storage/token_storage.dart';
import 'package:flutter_music_clean_getx/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_music_clean_getx/app/features/auth/presentation/login_page.dart';
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

  testWidgets('App boots to login route', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const ValueKey('auth.loginButton')), findsOneWidget);
  });
}