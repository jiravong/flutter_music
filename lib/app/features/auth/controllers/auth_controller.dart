import 'package:get/get.dart';

import '../../../core/storage/token_storage.dart';
import '../../../domain/usecases/login_usecase.dart';

// Presentation controller for authentication screen.
//
// Responsibility:
// - Hold UI state (loading/error).
// - Trigger domain use case.
// - Persist token and navigate on success.
class AuthController extends GetxController {
  AuthController({required this.loginUseCase, required this.tokenStorage});

  final LoginUseCase loginUseCase;
  final TokenStorage tokenStorage;

  // Observable UI state.
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Called by LoginPage.
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Execute login and store access token for subsequent API requests.
      final token = await loginUseCase(email: email, password: password);
      await tokenStorage.writeToken(token);

      // Replace navigation stack so user can't go back to login.
      Get.offAllNamed('/music');
    } catch (e) {
      // Keep error as text to show in UI.
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
