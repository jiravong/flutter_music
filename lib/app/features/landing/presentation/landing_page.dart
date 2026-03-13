import 'package:flutter/material.dart';
import 'package:music_roop/app/core/widgets/mini_player_bar.dart';
import 'package:music_roop/app/features/home/presentation/home_page.dart';
import 'package:music_roop/app/features/landing/controllers/landing_controller.dart';
import 'package:music_roop/app/features/music_list/presentation/music_list_page.dart';
import 'package:music_roop/app/features/profile/presentation/profile_page.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class LandingPage extends GetView<LandingController> {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack( // ใช้ IndexedStack เพื่อรักษา State ของหน้าเดิมไว้
        index: controller.tabIndex.value,
        children: [
          const HomePage(),      // มาจาก features/home
          const MusicListPage(), // มาจาก features/music_list
          const Center(child: Text('Explore')),
          const ProfilePage(),
        ],
      )),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayerBar(),
          Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.5),
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',key: ValueKey('landing.home')),
              BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music',key: ValueKey('landing.music')),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore',key: ValueKey('landing.explore')),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile',key: ValueKey('landing.profile')),
            ],
          )),
        ],
      ),
    );
  }
}