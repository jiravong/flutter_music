// Basic smoke test for app boot.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter_music_clean_getx/main.dart';

void main() {
  testWidgets('App boots to login route', (WidgetTester tester) async {
    await GetStorage.init();
    Get.reset();
    Get.testMode = true;

    await tester.pumpWidget(const MyApp(initialRoute: '/login'));

    // Avoid pumpAndSettle() here because GetMaterialApp / bindings can schedule
    // asynchronous work that may never fully settle in tests.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Login'), findsWidgets);
  });
}
