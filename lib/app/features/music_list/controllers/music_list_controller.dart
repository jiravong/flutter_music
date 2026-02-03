import 'package:get/get.dart';

import '../../../domain/entities/music.dart';
import '../../../domain/usecases/get_music_list_usecase.dart';
import '../../player/controllers/player_controller.dart';

class MusicListController extends GetxController {
  MusicListController({required this.getMusicListUseCase});

  final GetMusicListUseCase getMusicListUseCase;

  final musics = <Music>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final PlayerController _player = Get.find<PlayerController>();

  RxBool get isPlaying => _player.isPlaying;
  RxString get playingUrl => _player.playingUrl;

  Future<void> fetchMusicList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getMusicListUseCase();
      musics.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playUrl(String url) async {
    await _player.playUrl(url);
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
