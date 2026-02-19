import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../storage/token_storage.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/player/bindings/player_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GetStorage>()) {
      Get.put<GetStorage>(GetStorage(), permanent: true);
    }
    if (!Get.isRegistered<TokenStorage>()) {
      Get.put<TokenStorage>(
        TokenStorage(Get.find<GetStorage>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(
        ApiClient(Get.find<TokenStorage>()),
        permanent: true,
      );
    }

    PlayerBinding().dependencies();

    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(AuthRepositoryImpl(Get.find()), permanent: true);
    }
    if (!Get.isRegistered<LoginUseCase>()) {
      Get.put<LoginUseCase>(LoginUseCase(Get.find()), permanent: true);
    }
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(loginUseCase: Get.find(), tokenStorage: Get.find()),
        permanent: true,
      );
    }
  }
}
