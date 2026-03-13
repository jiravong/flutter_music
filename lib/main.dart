import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/core/config/app_config.dart';
import 'app/core/translations/app_translations.dart';
import 'app/core/services/analytics_service.dart';
import 'app/core/services/connectivity_service.dart';
import 'app/core/services/crashlytics_service.dart';
import 'app/core/services/remote_config_service.dart';
import 'app/core/themes/app_theme.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/storage/token_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'firebase_options_dev.dart';
import 'firebase_options_prod.dart';

// App entry point.
//
// We initialize GetStorage before running the app because we need to read
// persisted JWT token to decide the first screen.
Future<void> main() async {
  if (!AppConfig.isInitialized) {
    AppConfig.init(
      const AppConfig(
        flavor: Flavor.dev,
        appName: 'Music App (Dev)',
        apiBaseUrl: 'http://localhost:8080',
      ),
    );
  }

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: _firebaseOptions());
  await GetStorage.init();

  final crashlytics = Get.put<CrashlyticsService>(
    CrashlyticsService(),
    permanent: true,
  );
  await crashlytics.init();
  Get.put<AnalyticsService>(AnalyticsService(), permanent: true);

  final remoteConfig = Get.put<RemoteConfigService>(
    RemoteConfigService(),
    permanent: true,
  );
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
  final isLoggedIn = token != null && token.isNotEmpty;
  final initialRoute = isLoggedIn ? AppRoutes.landing : AppRoutes.login;

  // Initialize AuthService before runApp so middleware can use it synchronously
  final tokenStorage = TokenStorage(storage);
  final authService = Get.put<AuthService>(
    AuthService(tokenStorage),
    permanent: true,
  );
  authService.setLoggedIn(isLoggedIn);

  runApp(MyApp(initialRoute: initialRoute));
}

/// Returns [FirebaseOptions] matching the current [AppConfig.flavor].
FirebaseOptions _firebaseOptions() {
  switch (AppConfig.instance.flavor) {
    case Flavor.dev:
      return DevFirebaseOptions.currentPlatform;
    case Flavor.prod:
      return ProdFirebaseOptions.currentPlatform;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp enables GetX navigation and dependency bindings.
    return GetMaterialApp(
      title: AppConfig.instance.appName,
      translations: AppTranslations(),
      locale: const Locale('th', 'TH'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Switch automatically
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      navigatorObservers: [AnalyticsService.to.observer],
      // Note: AnalyticsService is registered in main() before runApp.
      // Route -> page mapping.
      getPages: AppPages.pages,
    );
  }
}
