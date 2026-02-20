import 'package:get/get.dart';

import '../services/connectivity_service.dart';
import '../services/crashlytics_service.dart';
import '../translations/app_strings.dart';

abstract class ErrorRecorder {
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal,
  });
}

mixin ErrorHandlerMixin on GetxController {
  RxString get errorMessage;

  ConnectivityService get connectivityService => ConnectivityService.to;
  ErrorRecorder get errorRecorder => CrashlyticsService.to;

  void handleError(Object e, StackTrace stack, {required String reason}) {
    final msg = e.toString();
    final clean = msg.startsWith('Exception: ') ? msg.substring(11) : msg;
    errorMessage.value = clean;

    final isOffline = !connectivityService.isConnected.value;
    if (isOffline) {
      showSnackbar(AppStrings.commonNoConnection.tr, clean);
      return;
    }

    errorRecorder.recordError(e, stack, reason: reason);
    showSnackbar(AppStrings.commonError.tr, clean);
  }

  void showSnackbar(String title, String message) {
    if (Get.isSnackbarOpen) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
