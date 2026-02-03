import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/music_list_controller.dart';

// Music list screen.
//
// Uses GetView to access MusicController injected by MusicBinding.
// Uses Obx to rebuild parts of UI based on observable variables.
class MusicListPage extends GetView<MusicListController> {
  const MusicListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple "first load" trigger.
    // In production, you might prefer onReady() inside controller.
    if (controller.musics.isEmpty && !controller.isLoading.value) {
      controller.fetchMusicList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Music')),
      body: Obx(() {
        // State: Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // State: Error
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        // State: Empty
        if (controller.musics.isEmpty) {
          return const Center(child: Text('No music found'));
        }

        // State: Success
        return RefreshIndicator(
          key: const ValueKey('musicList.refresh'),
          onRefresh: controller.fetchMusicList,
          child: ListView.separated(
            key: const ValueKey('musicList.listView'),
            itemCount: controller.musics.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final music = controller.musics[index];
              return ListTile(
                key: ValueKey('musicList.tile.${music.id}'),
                title: Text(music.title),
                subtitle: Text(music.artist),
                trailing: IconButton(
                  key: ValueKey('musicList.playButton.${music.id}'),
                  icon: Obx(() {
                    // Show play/pause icon based on controller playback state.
                    final isThisPlaying =
                        controller.playingUrl.value == music.mp3Url &&
                            controller.isPlaying.value;
                    return Icon(isThisPlaying ? Icons.pause : Icons.play_arrow);
                  }),
                  // Send mp3 url to controller to handle just_audio playback.
                  onPressed: () => controller.playUrl(music.mp3Url),
                ),
                onTap: () {
                  // Navigate to detail page and pass id via path + parameters.
                  Get.toNamed(
                    AppRoutes.musicDetail.replaceFirst(':id', '${music.id}'),
                    parameters: {'id': '${music.id}'},
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
