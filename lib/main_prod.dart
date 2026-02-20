import 'app/core/config/app_config.dart';
import 'main.dart' as runner;

Future<void> main() async {
  AppConfig.init(
    const AppConfig(
      flavor: Flavor.prod,
      appName: 'Music App',
      apiBaseUrl: 'https://api.yourproductiondomain.com',
    ),
  );
  await runner.main();
}
