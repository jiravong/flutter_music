import '../config/app_config.dart';

// Central place to keep API base URL and endpoint paths.
//
// Notes:
// - When running on Android emulator, you typically need to use 10.0.2.2
//   instead of localhost.
// - Paths here are relative and will be combined with baseUrl by ApiClient.
class ApiEndpoints {
  static String get baseUrl => AppConfig.instance.apiBaseUrl;

  // Auth
  static const String login = '/api/v1/auth/login';
  static const String refreshToken = '/api/v1/auth/refresh-token';
  static const String getUser = '/api/v1/user';

  // Music
  static const String music = '/api/v1/music/';
}
