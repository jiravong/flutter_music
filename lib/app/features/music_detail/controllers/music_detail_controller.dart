import 'package:get/get.dart';

import '../../../domain/entities/music.dart';
import '../../../domain/usecases/get_music_detail_usecase.dart';
import '../../player/controllers/player_controller.dart';

class MusicDetailController extends GetxController {
  MusicDetailController({required this.getMusicDetailUseCase});

  final GetMusicDetailUseCase getMusicDetailUseCase;

  final selectedMusic = Rxn<Music>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final PlayerController _player = Get.find<PlayerController>();

  RxBool get isPlaying => _player.isPlaying;
  RxString get playingUrl => _player.playingUrl;

  int? _lastFetchedId;

  int _readIdFromParams() {
    final idString = Get.parameters['id'] ?? '';
    return int.tryParse(idString) ?? 0;
  }

  void _fetchIfNeeded() {
    final id = _readIdFromParams();
    if (id == 0) return;
    if (_lastFetchedId == id) return;
    _lastFetchedId = id;

    Future.microtask(() => fetchMusicDetail(id));
  }

  @override
  void onReady() {
    super.onReady();
    _fetchIfNeeded();
  }

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

  Future<void> stop() async {
    await _player.stop();
  }
}
