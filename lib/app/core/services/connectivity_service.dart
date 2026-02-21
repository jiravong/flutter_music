import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  static ConnectivityService get to => Get.find<ConnectivityService>();

  final Connectivity _connectivity;
  final isConnected = true.obs;

  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    setupConnectivity();
  }

  void setupConnectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
    _checkInitial();
  }

  Future<void> _checkInitial() async {
    final results = await _connectivity.checkConnectivity();
    isConnected.value = _hasConnection(results);
  }

  void _onChanged(List<ConnectivityResult> results) {
    final connected = _hasConnection(results);
    if (!connected && isConnected.value) {
      isConnected.value = false;
      if (!Get.isSnackbarOpen && Get.overlayContext != null) {
        Get.snackbar(
          'ไม่มีการเชื่อมต่อ',
          'กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          isDismissible: false,
        );
      }
    } else if (connected && !isConnected.value) {
      isConnected.value = true;
      if (!Get.isSnackbarOpen && Get.overlayContext != null) {
        Get.snackbar(
          'เชื่อมต่อแล้ว',
          'การเชื่อมต่ออินเทอร์เน็ตกลับมาแล้ว',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
