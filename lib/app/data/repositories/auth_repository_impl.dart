import '../../core/constants/api_endpoints.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/api_client.dart';

// Data-layer implementation of AuthRepository.
//
// Responsibility:
// - Perform HTTP calls.
// - Parse response payload and return a domain-friendly result (token string).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<AuthTokens> login({required String email, required String password}) async {
    // Login endpoint typically does not require Authorization header.
    final response = await _client.post(
      ApiEndpoints.login,
      {
        'email': email,
        'password': password,
      },
    );

    // GetConnect exposes isOk for 2xx status codes.
    if (!response.isOk) {
      throw Exception(response.statusText ?? 'Login failed');
    }

    // Try to find token from a few common response shapes:
    // - { access_token: "...", refresh_token: "..." }
    // - { token: "...", refresh_token: "..." }
    // - { data: { access_token/token: "...", refresh_token: "..." } }
    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = (body['data'] is Map<String, dynamic>)
          ? body['data'] as Map<String, dynamic>
          : body;

      final accessToken = data['access_token'] ?? data['token'];
      final refreshToken = data['refresh_token'];

      if (accessToken is String &&
          accessToken.isNotEmpty &&
          refreshToken is String &&
          refreshToken.isNotEmpty) {
        return AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
    }

    throw Exception('Token not found in response');
  }
}
