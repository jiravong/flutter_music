import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../domain/entities/music.dart';
import '../../../domain/usecases/get_music_detail_usecase.dart';
import '../../../domain/usecases/get_music_list_usecase.dart';

// Presentation controller for music list/detail screens.
//
// Responsibility:
// - Fetch data through domain use cases.
// - Expose observable states for UI (loading/error/data).
// - Control audio playback (just_audio) using a URL provided by UI.
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

  // Playback state.
  final isPlaying = false.obs;
  final playingUrl = ''.obs;

  late final AudioPlayer _player;

  @override
  void onInit() {
    // Create player once per controller lifecycle.
    _player = AudioPlayer();
    super.onInit();
  }

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

  // Toggle play/pause for a given remote url.
  //
  // UI passes the mp3 url (from list/detail), controller manages the player.
  Future<void> playUrl(String url) async {
    try {
      errorMessage.value = '';
      if (url.isEmpty) {
        throw Exception('Empty url');
      }

      // If user taps the same item while playing, pause it.
      if (playingUrl.value == url && _player.playing) {
        await _player.pause();
        isPlaying.value = false;
        return;
      }

      // Otherwise switch to the new URL and start playing.
      playingUrl.value = url;
      await _player.setUrl(url);
      await _player.play();
      isPlaying.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
      isPlaying.value = false;
    }
  }

  // Stop playback.
  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
  }

  @override
  void onClose() {
    // Always dispose resources.
    _player.dispose();
    super.onClose();
  }
}
