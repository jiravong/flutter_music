import 'package:get_storage/get_storage.dart';

// Simple local persistence layer for auth token.
//
// Responsibility:
// - Read/write/clear JWT access token from GetStorage.
// - Keep storage access behind a small abstraction so the rest of the app
//   (ApiClient/Controllers) doesn't depend on GetStorage API directly.
class TokenStorage {
  // GetStorage instance is injected to make this class testable and reusable.
  TokenStorage(this._box);

  final GetStorage _box;

  // Storage key used across the app.
  // Must match the key that main.dart uses to decide the initial route.
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Returns saved token (if any). Null means not logged in.
  String? readToken() {
    return _box.read<String>(_tokenKey);
  }

  // Persist token after successful login.
  Future<void> writeToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  String? readRefreshToken() {
    return _box.read<String>(_refreshTokenKey);
  }

  Future<void> writeRefreshToken(String token) async {
    await _box.write(_refreshTokenKey, token);
  }

  // Remove token on logout.
  Future<void> clearToken() async {
    await _box.remove(_tokenKey);
    await _box.remove(_refreshTokenKey);
  }
}
