import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_clean_getx/app/features/landing/controllers/landing_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack( // ใช้ IndexedStack เพื่อรักษา State ของหน้าเดิมไว้
        index: controller.tabIndex.value,
        children: [
          // const HomeView(),      // มาจาก features/home
          // const MusicListView(), // มาจาก features/music_list
          // const ExploreView(),
          // const ProfileView(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.tabIndex.value,
        onTap: controller.changeTabIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      )),
    );
  }
}