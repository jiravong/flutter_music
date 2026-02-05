import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../storage/token_storage.dart';
import '../../data/providers/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GetStorage>()) {
      Get.put<GetStorage>(GetStorage(), permanent: true);
    }
    if (!Get.isRegistered<TokenStorage>()) {
      Get.put<TokenStorage>(
        TokenStorage(Get.find<GetStorage>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(
        ApiClient(Get.find<TokenStorage>()),
        permanent: true,
      );
    }
  }
}
