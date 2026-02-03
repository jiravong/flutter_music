import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/storage/token_storage.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../controllers/auth_controller.dart';

// Bindings are GetX's dependency injection entry point for a route.
//
// This binding wires the full dependency chain for the login feature:
// GetStorage -> TokenStorage -> ApiClient -> AuthRepository -> LoginUseCase -> AuthController
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Storage
    Get.lazyPut<GetStorage>(() => GetStorage());
    Get.lazyPut<TokenStorage>(() => TokenStorage(Get.find()));

    // Network client (will attach token if available)
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find()));

    // Data -> Domain
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find()));

    // Presentation
    Get.lazyPut<AuthController>(
      () => AuthController(loginUseCase: Get.find(), tokenStorage: Get.find()),
    );
  }
}
