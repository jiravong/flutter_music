import 'package:flutter_music_clean_getx/app/data/repositories/user_repository_impl.dart';
import 'package:get/get.dart';

import '../../../domain/repositories/user_repository.dart';
import '../../../domain/usecases/user_usecase.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserRepository>()) {
      Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find()));
    }
    if (!Get.isRegistered<UserUsecase>()) {
      Get.lazyPut<UserUsecase>(() => UserUsecase(Get.find()));
    }
  
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(() => ProfileController(userUsecase: Get.find()));
    }
  }
}
