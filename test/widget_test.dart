// Basic smoke test for app boot.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_music_clean_getx/main.dart';

void main() {
  testWidgets('App boots to login route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/login'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);
  });
}
