import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_music_clean_getx/app/core/storage/token_storage.dart';
import 'package:flutter_music_clean_getx/app/domain/entities/auth_tokens.dart';
import 'package:flutter_music_clean_getx/app/domain/repositories/auth_repository.dart';
import 'package:flutter_music_clean_getx/app/domain/usecases/login_usecase.dart';
import 'package:flutter_music_clean_getx/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_music_clean_getx/app/features/auth/presentation/login_page.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthTokens> login({required String email, required String password}) async {
    return const AuthTokens(accessToken: 'fake_access', refreshToken: 'fake_refresh');
  }
}

class FakeTokenStorage implements TokenStorage {
  String? _token;
  String? _refreshToken;

  @override
  String? readToken() => _token;

  @override
  Future<void> writeToken(String token) async {
    _token = token;
  }

  @override
  String? readRefreshToken() => _refreshToken;

  @override
  Future<void> writeRefreshToken(String token) async {
    _refreshToken = token;
  }

  @override
  Future<void> clearToken() async {
    _token = null;
    _refreshToken = null;
  }
}

class TestAuthController extends AuthController {
  TestAuthController()
      : super(
          loginUseCase: LoginUseCase(FakeAuthRepository()),
          tokenStorage: FakeTokenStorage(),
        );
}

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.put<AuthController>(TestAuthController());
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
