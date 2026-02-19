import 'package:get/get.dart';

import '../../../domain/entities/music.dart';
import '../../../domain/usecases/get_music_detail_usecase.dart';
import '../../../domain/usecases/get_music_list_usecase.dart';
import '../../player/controllers/player_controller.dart';

// Presentation controller for music list/detail screens.
//
// Responsibility:
// - Fetch data through domain use cases.
// - Expose observable states for UI (loading/error/data).
// - Delegate audio playback to PlayerController.
class MusicController extends GetxController {
  MusicController({
    required this.getMusicListUseCase,
    required this.getMusicDetailUseCase,
  });

  final GetMusicListUseCase getMusicListUseCase;
  final GetMusicDetailUseCase getMusicDetailUseCase;

  // Observable data for list screen.
  final musics = <Music>[].obs;

  // Observable data for detail screen.
  final selectedMusic = Rxn<Music>();

  // Generic UI state (shared by list and detail pages in this simple example).
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final PlayerController _player = Get.find<PlayerController>();

  RxBool get isPlaying => _player.isPlaying;
  RxString get playingUrl => _player.playingUrl;

  bool isPlayingUrl(String url) => _player.isPlayingUrl(url);

  // Fetch music list and update `musics`.
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

  // Fetch music detail and update `selectedMusic`.
  Future<void> fetchMusicDetail(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getMusicDetailUseCase(id);
      selectedMusic.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playUrl(String url) async {
    await _player.playUrl(url);
  }

  Future<void> playMusic(Music music) async {
    await _player.playMusic(music);
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
