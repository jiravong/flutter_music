import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../mixins/error_handler_mixin.dart';

class CrashlyticsService extends GetxService implements ErrorRecorder {
  CrashlyticsService({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  static CrashlyticsService get to => Get.find<CrashlyticsService>();

  final FirebaseCrashlytics _crashlytics;

  Future<void> init() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  void recordFlutterError(FlutterErrorDetails details) {
    _crashlytics.recordFlutterFatalError(details);
  }

  ErrorCallback get onPlatformError => (Object error, StackTrace stack) {
    recordError(error, stack, fatal: true);
    return true;
  };
}
