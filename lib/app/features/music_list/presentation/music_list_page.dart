import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_colors.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/cached_image.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../routes/app_routes.dart';
import '../controllers/music_list_controller.dart';

// Music list screen.
//
// Uses GetView to access MusicController injected by MusicBinding.
// Uses Obx to rebuild parts of UI based on observable variables.
class MusicListPage extends StatefulWidget {
  const MusicListPage({super.key});

  @override
  State<MusicListPage> createState() => _MusicListPageState();
}

class _MusicListPageState extends State<MusicListPage> {
  late final MusicListController controller;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<MusicListController>();
    if (controller.musics.isEmpty && !controller.isLoading.value) {
      controller.fetchMusicList();
    }
  }

  Future<void> _onRefresh() async {
    await controller.fetchMusicList();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoadMore() async {
    if (!controller.hasMore) {
      _refreshController.loadNoData();
      return;
    }
    await controller.loadMore();
    if (controller.hasMore) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
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
        return SmartRefresher(
          key: const ValueKey('musicList.refresh'),
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoadMore,
          footer: ClassicFooter(
            loadingText: '',
            noDataText: '',
            idleText: '',
            canLoadingText: '',
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          child: ListView.separated(
            key: const ValueKey('musicList.listView'),
            itemCount: controller.musics.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final music = controller.musics[index];
              return ListTile(
                key: ValueKey('musicList.tile.${music.id}'),
                title: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CoreImageNetwork(
                          imageUrl: music.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(music.title, style: AppTextStyle.textSmBold),
                        Text(
                          music.artist,
                          style: AppTextStyle.textXsRegular.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  key: ValueKey('musicList.playButton.${music.id}'),
                  icon: Obx(() {
                    final isThisPlaying = controller.isPlayingUrl(music.mp3Url);
                    final activeColor = AppColors.white;
                    final inactiveColor = AppColors.primary;
                    return Icon(isThisPlaying ? Icons.pause : Icons.play_arrow, color: isThisPlaying ? activeColor : inactiveColor);
                  }),
                  onPressed: () => controller.playMusic(music),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.musicDetail.replaceFirst(':id', '${music.id}'), parameters: {'id': '${music.id}'});
                },
              );
            },
          ),
        );
      }),
    );
  }
}
