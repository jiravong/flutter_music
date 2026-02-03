import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/music_detail_controller.dart';

// Music detail screen.
//
// Reads `id` from Get.parameters and asks controller to fetch detail.
// Uses Obx to render loading/error/success states.
class MusicDetailPage extends StatefulWidget {
  const MusicDetailPage({super.key});

  @override
  State<MusicDetailPage> createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  final MusicDetailController controller = Get.find<MusicDetailController>();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMusicDetail(id);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Detail')),
      body: Obx(() {
        // State: Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // State: Error
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final music = controller.selectedMusic.value;
        if (music == null) {
          return const Center(child: Text('No detail'));
        }

        // State: Success
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                music.title,
                key: const ValueKey('musicDetail.title'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                music.artist,
                key: const ValueKey('musicDetail.artist'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  key: const ValueKey('musicDetail.lyricsScroll'),
                  child: Text(music.lyrics, key: const ValueKey('musicDetail.lyrics')),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // Delegate playback to controller.
                      key: const ValueKey('musicDetail.playButton'),
                      onPressed: () => controller.playUrl(music.mp3Url),
                      child: Obx(() {
                        final isThisPlaying =
                            controller.playingUrl.value == music.mp3Url &&
                                controller.isPlaying.value;
                        return Text(isThisPlaying ? 'Pause' : 'Play');
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final isThisPlaying =
                          controller.playingUrl.value == music.mp3Url &&
                              controller.isPlaying.value;
                      return ElevatedButton(
                        key: const ValueKey('musicDetail.stopButton'),
                        onPressed: isThisPlaying ? controller.stop : null,
                        child: const Text('Stop'),
                      );
                    }),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
