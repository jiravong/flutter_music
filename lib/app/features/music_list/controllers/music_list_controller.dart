import 'package:get/get.dart';

import '../../../core/mixins/error_handler_mixin.dart';
import '../../../domain/entities/music.dart';
import '../../../domain/usecases/get_music_page_usecase.dart';
import '../../player/controllers/player_controller.dart';

class MusicListController extends GetxController with ErrorHandlerMixin {
  MusicListController({required this.getMusicPageUseCase});

  final GetMusicPageUseCase getMusicPageUseCase;

  final musics = <Music>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  @override
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
    isLoading.value = true;
    errorMessage.value = '';
    _currentPage = 1;
    _hasMore = true;

    final result = await getMusicPageUseCase(page: _currentPage, limit: _limit);
    result.when(
      success: (pageData) {
        musics.assignAll(pageData.items);
        _hasMore = pageData.hasMore;
      },
      failure: (e, stack) {
        handleError(e, stack ?? StackTrace.current, reason: 'fetchMusicList');
      },
    );
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    _currentPage++;

    final result = await getMusicPageUseCase(page: _currentPage, limit: _limit);
    result.when(
      success: (pageData) {
        musics.addAll(pageData.items);
        _hasMore = pageData.hasMore;
      },
      failure: (e, stack) {
        _currentPage--;
        handleError(e, stack ?? StackTrace.current, reason: 'loadMore');
      },
    );
    isLoadingMore.value = false;
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
