import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_music_clean_getx/app/core/mixins/error_handler_mixin.dart';
import 'package:flutter_music_clean_getx/app/core/services/connectivity_service.dart';

// ── Fakes ────────────────────────────────────────────────────────────────────

// Lightweight fake — skips platform channel by overriding setupConnectivity.
class FakeConnectivityService extends ConnectivityService {
  @override
  void setupConnectivity() {}
}

// Lightweight fake — implements ErrorRecorder without touching Firebase.
class FakeCrashlyticsService implements ErrorRecorder {
  final List<({Object error, String reason})> recorded = [];

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    recorded.add((error: exception as Object, reason: reason ?? ''));
  }
}

// ── Test controller ───────────────────────────────────────────────────────────

class TestController extends GetxController with ErrorHandlerMixin {
  late FakeConnectivityService fakeConnectivity;
  late FakeCrashlyticsService fakeCrashlytics;

  @override
  final errorMessage = ''.obs;

  @override
  ConnectivityService get connectivityService => fakeConnectivity;

  @override
  ErrorRecorder get errorRecorder => fakeCrashlytics;

  @override
  void showSnackbar(String title, String message) {
    // no-op in tests — no overlay available
  }
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late FakeConnectivityService fakeConnectivity;
  late FakeCrashlyticsService fakeCrashlytics;
  late TestController controller;

  setUp(() {
    Get.reset();
    Get.testMode = true;

    fakeConnectivity = FakeConnectivityService();
    fakeCrashlytics = FakeCrashlyticsService();

    controller = Get.put(TestController()
      ..fakeConnectivity = fakeConnectivity
      ..fakeCrashlytics = fakeCrashlytics);
  });

  tearDown(() => Get.reset());

  group('handleError — online', () {
    setUp(() => fakeConnectivity.isConnected.value = true);

    test('strips "Exception: " prefix from errorMessage', () {
      controller.handleError(
        Exception('something went wrong'),
        StackTrace.empty,
        reason: 'test',
      );

      expect(controller.errorMessage.value, 'something went wrong');
    });

    test('keeps message as-is when no Exception prefix', () {
      controller.handleError(
        'raw error',
        StackTrace.empty,
        reason: 'test',
      );

      expect(controller.errorMessage.value, 'raw error');
    });

    test('records error to Crashlytics', () {
      controller.handleError(
        Exception('api error'),
        StackTrace.empty,
        reason: 'fetchData',
      );

      expect(fakeCrashlytics.recorded.length, 1);
      expect(fakeCrashlytics.recorded.first.reason, 'fetchData');
    });
  });

  group('handleError — offline', () {
    setUp(() => fakeConnectivity.isConnected.value = false);

    test('still sets errorMessage when offline', () {
      controller.handleError(
        Exception('network error'),
        StackTrace.empty,
        reason: 'fetchData',
      );

      expect(controller.errorMessage.value, 'network error');
    });

    test('does NOT record to Crashlytics when offline', () {
      controller.handleError(
        Exception('network error'),
        StackTrace.empty,
        reason: 'fetchData',
      );

      expect(fakeCrashlytics.recorded, isEmpty);
    });
  });
}
