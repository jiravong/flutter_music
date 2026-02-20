import 'app/core/config/app_config.dart';
import 'main.dart' as runner;

Future<void> main() async {
  AppConfig.init(
    const AppConfig(
      flavor: Flavor.dev,
      appName: 'Music App (Dev)',
      apiBaseUrl: 'http://localhost:8080',
    ),
  );
  await runner.main();
}
