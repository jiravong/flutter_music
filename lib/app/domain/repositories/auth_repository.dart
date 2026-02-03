// Domain contract for authentication-related operations.
//
// Implementations live in the Data layer (e.g. AuthRepositoryImpl).

import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  // Returns JWT access token on success.
  Future<AuthTokens> login({required String email, required String password});
}
