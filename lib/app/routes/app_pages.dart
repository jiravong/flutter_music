import 'package:flutter_music_clean_getx/app/features/home/binding/home_binding.dart';
import 'package:flutter_music_clean_getx/app/features/home/presentation/home_page.dart';
import 'package:get/get.dart';

import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/music_detail/bindings/music_detail_binding.dart';
import '../features/music_list/bindings/music_binding.dart';
import '../features/player/bindings/player_binding.dart';
import '../features/music_detail/presentation/music_detail_page.dart';
import '../features/music_list/presentation/music_list_page.dart';
import 'app_routes.dart';

// Central list of all GetX pages.
//
// Each GetPage can have a Binding which provides dependency injection for that
// route (controllers, use cases, repositories, etc.).
class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.music,
      page: () => const MusicListPage(),
      bindings: [PlayerBinding(), MusicBinding()],
    ),
    GetPage(
      name: AppRoutes.musicDetail,
      page: () => const MusicDetailPage(),
      bindings: [PlayerBinding(), MusicDetailBinding()],
    ),
  ];
}
