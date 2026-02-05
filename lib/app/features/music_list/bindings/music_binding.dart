import 'package:get/get.dart';

import '../../../data/repositories/music_repository_impl.dart';
import '../../../domain/repositories/music_repository.dart';
import '../../../domain/usecases/get_music_list_usecase.dart';
import '../controllers/music_list_controller.dart';

// Bindings for music screens.
//
// Dependency chain:
// GetStorage -> TokenStorage -> ApiClient -> MusicRepository -> UseCases -> MusicController
class MusicBinding extends Bindings {
  @override
  void dependencies() {
    // Data -> Domain
    if (!Get.isRegistered<MusicRepository>()) {
      Get.lazyPut<MusicRepository>(() => MusicRepositoryImpl(Get.find()));
    }
    if (!Get.isRegistered<GetMusicListUseCase>()) {
      Get.lazyPut<GetMusicListUseCase>(() => GetMusicListUseCase(Get.find()));
    }

    // Presentation
    if (!Get.isRegistered<MusicListController>()) {
      Get.lazyPut<MusicListController>(
        () => MusicListController(getMusicListUseCase: Get.find()),
      );
    }
  }
}
