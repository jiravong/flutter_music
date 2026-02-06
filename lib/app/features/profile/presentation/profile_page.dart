import 'package:flutter/material.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/appbar/appbar.dart';
import 'package:flutter_music_clean_getx/app/core/widgets/base_layout.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CoreAppBar(title: 'Profile', showBackButton: true),
      body: Obx(() => Center(
        child: Text(
          'Profile ${controller.user.value?.fullName ?? '---'}',
          style: const TextStyle(fontSize: 24),
        ),
      )),
    );
  }
}
