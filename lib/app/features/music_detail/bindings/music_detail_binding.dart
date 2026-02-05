import 'package:get/get.dart';

import '../../../data/repositories/music_repository_impl.dart';
import '../../../domain/repositories/music_repository.dart';
import '../../../domain/usecases/get_music_detail_usecase.dart';
import '../controllers/music_detail_controller.dart';

class MusicDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MusicRepository>(() => MusicRepositoryImpl(Get.find()));
    Get.lazyPut<GetMusicDetailUseCase>(() => GetMusicDetailUseCase(Get.find()));

    Get.lazyPut<MusicDetailController>(
      () => MusicDetailController(getMusicDetailUseCase: Get.find()),
    );
  }
}
