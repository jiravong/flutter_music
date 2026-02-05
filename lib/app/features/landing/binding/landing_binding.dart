import 'package:flutter_music_clean_getx/app/features/landing/controllers/landing_controller.dart';
import 'package:get/get.dart';

import '../../home/binding/home_binding.dart';

// Bindings are GetX's dependency injection entry point for a route.
//
// This binding wires the full dependency chain for the login feature:
// GetStorage -> TokenStorage -> ApiClient -> AuthRepository -> LoginUseCase -> AuthController
class LandingBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();

    if (!Get.isRegistered<LandingController>()) {
      Get.lazyPut<LandingController>(() => LandingController());
    }
  }
}
