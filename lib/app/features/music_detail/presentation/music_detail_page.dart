import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/appbar/appbar.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:get/get.dart';

import '../controllers/music_detail_controller.dart';

// Music detail screen.
//
// Reads `id` from Get.parameters and asks controller to fetch detail.
// Uses Obx to render loading/error/success states.
class MusicDetailPage extends GetView<MusicDetailController> {
  const MusicDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CoreAppBar(title: 'Music Detail', showBackButton: true),
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
              Image.network(music.imageUrl),
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
