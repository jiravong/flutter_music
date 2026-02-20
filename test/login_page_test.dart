import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_music_clean_getx/app/core/services/auth_service.dart';
import 'package:flutter_music_clean_getx/app/core/storage/token_storage.dart';
import 'package:flutter_music_clean_getx/app/domain/entities/auth_tokens.dart';
import 'package:flutter_music_clean_getx/app/domain/repositories/auth_repository.dart';
import 'package:flutter_music_clean_getx/app/domain/usecases/login_usecase.dart';
import 'package:flutter_music_clean_getx/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_music_clean_getx/app/features/auth/presentation/login_page.dart';

import 'fakes.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthTokens> login({required String email, required String password}) async {
    return const AuthTokens(accessToken: 'fake_access', refreshToken: 'fake_refresh');
  }
}

class TestAuthController extends AuthController {
  TestAuthController(TokenStorage tokenStorage)
      : super(
          loginUseCase: LoginUseCase(FakeAuthRepository()),
          tokenStorage: tokenStorage,
        );
}

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
