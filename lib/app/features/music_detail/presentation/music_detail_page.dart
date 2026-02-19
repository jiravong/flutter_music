import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_colors.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/appbar/appbar.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/cached_image.dart';
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
    return Obx(() {
      // State: Loading
      if (controller.isLoading.value) {
        return BaseScaffold(
          appBar: CoreAppBar(title: 'Music Detail', showBackButton: true),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      // State: Error
      if (controller.errorMessage.value.isNotEmpty) {
        return BaseScaffold(
          appBar: CoreAppBar(title: 'Music Detail', showBackButton: true),
          body: Center(child: Text(controller.errorMessage.value)),
        );
      }

      final music = controller.selectedMusic.value;
      if (music == null) {
        return BaseScaffold(
          appBar: CoreAppBar(title: 'Music Detail', showBackButton: true),
          body: const Center(child: Text('No detail')),
        );
      }

      // State: Success
      return BaseScaffold(
        appBar: CoreAppBar(title: music.title, showBackButton: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoreImageNetwork(imageUrl: music.imageUrl),
              Text(
                'นักร้อง: ${music.artist}',
                key: const ValueKey('musicDetail.artist'),
                style: AppTextStyle.textSmRegular.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  key: const ValueKey('musicDetail.lyricsScroll'),
                  child: Text(music.lyrics, key: const ValueKey('musicDetail.lyrics'), style: AppTextStyle.textSmRegular),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // Delegate playback to controller.
                      key: const ValueKey('musicDetail.playButton'),
                      onPressed: () => controller.playMusic(music),
                      child: Obx(() {
                        final isThisPlaying = controller.isPlayingUrl(music.mp3Url);
                        return Text(isThisPlaying ? 'Pause' : 'Play');
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final isThisPlaying = controller.isPlayingUrl(music.mp3Url);
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
        ),
      );
    });
  }
}
