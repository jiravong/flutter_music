import '../../core/constants/api_endpoints.dart';
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
  Future<String> login({required String email, required String password}) async {
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
    // - { access_token: "..." }
    // - { token: "..." }
    // - { data: { access_token/token: "..." } }
    final body = response.body;
    if (body is Map<String, dynamic>) {
      final token = body['access_token'] ??
          body['token'] ??
          (body['data'] is Map<String, dynamic>
              ? (body['data'] as Map<String, dynamic>)['access_token'] ??
                  (body['data'] as Map<String, dynamic>)['token']
              : null);

      if (token is String && token.isNotEmpty) return token;
    }

    throw Exception('Token not found in response');
  }
}
