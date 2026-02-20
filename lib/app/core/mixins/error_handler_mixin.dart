import 'package:get/get.dart';

import '../services/crashlytics_service.dart';

mixin ErrorHandlerMixin on GetxController {
  RxString get errorMessage;

  void handleError(Object e, StackTrace stack, {required String reason}) {
    final msg = e.toString();
    final clean = msg.startsWith('Exception: ') ? msg.substring(11) : msg;
    errorMessage.value = clean;
    CrashlyticsService.to.recordError(e, stack, reason: reason);
    Get.snackbar(
      'เกิดข้อผิดพลาด',
      clean,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
