import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

// App entry point.
//
// We initialize GetStorage before running the app because we need to read
// persisted JWT token to decide the first screen.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Read token directly for a quick initialRoute decision.
  // (TokenStorage abstraction is used elsewhere; here we keep it minimal.)
  final box = GetStorage();
  final token = box.read<String>('access_token');

  // If token exists, go directly to music list. Otherwise, show login page.
  final initialRoute =
      (token != null && token.isNotEmpty) ? AppRoutes.home : AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp enables GetX navigation and dependency bindings.
    return GetMaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      // Route -> page mapping.
      getPages: AppPages.pages,
    );
  }
}
