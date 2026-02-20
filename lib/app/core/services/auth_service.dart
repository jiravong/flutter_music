import 'package:get/get.dart';
import '../storage/token_storage.dart';

// Global reactive service to hold the authentication state.
// This allows GetMiddleware to check auth status synchronously.
class AuthService extends GetxService {
  AuthService(this._tokenStorage);

  static AuthService get to => Get.find<AuthService>();

  final TokenStorage _tokenStorage;
  final isLoggedIn = false.obs;

  Future<void> init() async {
    final token = await _tokenStorage.readToken();
    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  void setLoggedIn(bool value) {
    isLoggedIn.value = value;
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
