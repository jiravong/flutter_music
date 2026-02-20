import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Secure persistence layer for auth token.
//
// Responsibility:
// - Read/write/clear JWT access token from FlutterSecureStorage.
// - Keep storage access behind a small abstraction so the rest of the app
//   (ApiClient/Controllers) doesn't depend on SecureStorage API directly.
class TokenStorage {
  // FlutterSecureStorage instance is injected to make this class testable and reusable.
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  // Storage key used across the app.
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Returns saved token (if any). Null means not logged in.
  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Persist token after successful login.
  Future<void> writeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> writeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // Remove token on logout.
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
