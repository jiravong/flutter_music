import 'package:get/get.dart';

import '../../../core/services/crashlytics_service.dart';
import '../../../domain/entities/music.dart';
import '../../../domain/usecases/get_music_page_usecase.dart';
import '../../player/controllers/player_controller.dart';

class MusicListController extends GetxController {
  MusicListController({required this.getMusicPageUseCase});

  final GetMusicPageUseCase getMusicPageUseCase;

  final musics = <Music>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  int _currentPage = 1;
  static const int _limit = 10;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  final PlayerController _player = Get.find<PlayerController>();

  RxBool get isPlaying => _player.isPlaying;
  RxString get playingUrl => _player.playingUrl;

  bool isPlayingUrl(String url) => _player.isPlayingUrl(url);

  Future<void> fetchMusicList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _currentPage = 1;
      _hasMore = true;

      final result = await getMusicPageUseCase(page: _currentPage, limit: _limit);
      musics.assignAll(result.items);
      _hasMore = result.hasMore;
    } catch (e, stack) {
      errorMessage.value = e.toString();
      CrashlyticsService.to.recordError(e, stack, reason: 'fetchMusicList');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value) return;
    try {
      isLoadingMore.value = true;
      _currentPage++;

      final result = await getMusicPageUseCase(page: _currentPage, limit: _limit);
      musics.addAll(result.items);
      _hasMore = result.hasMore;
    } catch (e, stack) {
      _currentPage--;
      errorMessage.value = e.toString();
      CrashlyticsService.to.recordError(e, stack, reason: 'loadMore');
    } finally {
      isLoadingMore.value = false;
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
