import 'package:flutter_music_clean_getx/app/features/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../music_list/bindings/music_binding.dart';
import '../../player/bindings/player_binding.dart';

// Bindings are GetX's dependency injection entry point for a route.
//
// This binding wires the full dependency chain for the login feature:
// GetStorage -> TokenStorage -> ApiClient -> AuthRepository -> LoginUseCase -> AuthController
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Presentation
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    PlayerBinding().dependencies();
    MusicBinding().dependencies();
  }
}
