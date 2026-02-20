import 'package:flutter_music_clean_getx/app/core/services/analytics_service.dart';
import 'package:flutter_music_clean_getx/app/core/services/crashlytics_service.dart';
import 'package:flutter_music_clean_getx/app/core/storage/token_storage.dart';
import 'package:flutter_music_clean_getx/app/data/models/user_model.dart';
import 'package:flutter_music_clean_getx/app/domain/usecases/user_usecase.dart';
import 'package:flutter_music_clean_getx/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  ProfileController({required this.userUsecase});

  final UserUsecase userUsecase;
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final user = Rxn<UserModel>(null);
  
  @override
  void onInit() {
    super.onInit();
    getUser();
  }
  
  Future<void> getUser() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      user.value = await userUsecase.getUser();
    } catch (e, stack) {
      errorMessage.value = e.toString();
      CrashlyticsService.to.recordError(e, stack, reason: 'getUser');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await AnalyticsService.to.logLogout();
    await _tokenStorage.clearToken();
    Get.offAllNamed(AppRoutes.login);
  }
}
