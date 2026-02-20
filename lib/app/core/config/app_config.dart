enum Flavor { dev, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
  });

  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;

  static AppConfig? _instance;

  static bool get isInitialized => _instance != null;

  static AppConfig get instance {
    assert(_instance != null, 'AppConfig.init() must be called before accessing AppConfig.instance');
    return _instance!;
  }

  static void init(AppConfig config) {
    _instance = config;
  }

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;
}
