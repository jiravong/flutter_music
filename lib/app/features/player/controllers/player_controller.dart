import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PlayerController extends GetxController {
  final isPlaying = false.obs;
  final playingUrl = ''.obs;
  final errorMessage = ''.obs;

  late final AudioPlayer _player;

  @override
  void onInit() {
    _player = AudioPlayer();
    super.onInit();
  }

  Future<void> playUrl(String url) async {
    try {
      errorMessage.value = '';
      if (url.isEmpty) {
        throw Exception('Empty url');
      }

      if (playingUrl.value == url && _player.playing) {
        await _player.pause();
        isPlaying.value = false;
        return;
      }

      playingUrl.value = url;
      await _player.setUrl(url);
      await _player.play();
      isPlaying.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
      isPlaying.value = false;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
