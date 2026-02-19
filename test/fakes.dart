import 'package:get/get.dart';

import 'package:flutter_music_clean_getx/app/features/player/controllers/player_controller.dart';
import 'package:flutter_music_clean_getx/app/domain/entities/music.dart';

class FakePlayerController extends GetxController implements PlayerController {
  @override
  final isPlaying = false.obs;

  @override
  final playingUrl = ''.obs;

  @override
  final errorMessage = ''.obs;

  @override
  final currentMusic = Rxn<Music>();

  @override
  bool isPlayingUrl(String url) {
    return playingUrl.value == url && isPlaying.value;
  }

  @override
  bool isPlayingMusic(Music music) {
    return isPlayingUrl(music.mp3Url);
  }

  @override
  Future<void> playMusic(Music music) async {
    currentMusic.value = music;
    await playUrl(music.mp3Url);
  }

  @override
  Future<void> playUrl(String url) async {
    if (url.isEmpty) {
      errorMessage.value = 'Empty url';
      isPlaying.value = false;
      return;
    }
    if (playingUrl.value == url && isPlaying.value) {
      isPlaying.value = false;
      return;
    }
    playingUrl.value = url;
    isPlaying.value = true;
  }

  @override
  Future<void> stop() async {
    isPlaying.value = false;
  }

  @override
  void onInit() {
    // no-op in tests
    super.onInit();
  }

  @override
  void onClose() {
    // no-op in tests
    super.onClose();
  }
}
