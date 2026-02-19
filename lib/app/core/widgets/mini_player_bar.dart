import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/cached_image.dart';
import 'package:flutter_music_clean_getx/app/features/player/controllers/player_controller.dart';
import 'package:get/get.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      final music = controller.currentMusic.value;
      if (music == null) return const SizedBox.shrink();

      return Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 6,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CoreImageNetwork(
                  imageUrl: music.imageUrl,
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        music.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        music.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final isThisPlaying = controller.isPlayingMusic(music);
                  final activeColor = Theme.of(context).colorScheme.primary;
                  final inactiveColor =
                      Theme.of(context).iconTheme.color?.withValues(alpha: 0.45);
                  return IconButton(
                    icon: Icon(
                      isThisPlaying ? Icons.pause : Icons.play_arrow,
                      color: isThisPlaying ? activeColor : inactiveColor,
                    ),
                    onPressed: () async {
                      print('play music: ${isThisPlaying}');
                      await controller.playMusic(music);
                      final message = controller.errorMessage.value;
                      if (message.isNotEmpty) {
                        Get.snackbar('Player error', message);
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
