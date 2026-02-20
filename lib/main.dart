import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/core/services/analytics_service.dart';
import 'app/core/services/connectivity_service.dart';
import 'app/core/services/crashlytics_service.dart';
import 'app/core/services/remote_config_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'firebase_options.dart';

// App entry point.
//
// We initialize GetStorage before running the app because we need to read
// persisted JWT token to decide the first screen.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  final crashlytics = Get.put<CrashlyticsService>(CrashlyticsService(), permanent: true);
  await crashlytics.init();
  Get.put<AnalyticsService>(AnalyticsService(), permanent: true);

  final remoteConfig = Get.put<RemoteConfigService>(RemoteConfigService(), permanent: true);
  await remoteConfig.init();
  Get.put<ConnectivityService>(ConnectivityService(), permanent: true);

  // Catch Flutter framework errors.
  FlutterError.onError = CrashlyticsService.to.recordFlutterError;
  // Catch async errors outside Flutter.
  PlatformDispatcher.instance.onError = CrashlyticsService.to.onPlatformError;

  // Read token directly for a quick initialRoute decision.
  // (TokenStorage abstraction is used elsewhere; here we keep it minimal.)
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'access_token');
  final initialRoute = (token != null && token.isNotEmpty) ? AppRoutes.landing : AppRoutes.login;

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
      navigatorObservers: [
        AnalyticsService.to.observer,
      ],
      // Note: AnalyticsService is registered in main() before runApp.
      // Route -> page mapping.
      getPages: AppPages.pages,
    );
  }
}
