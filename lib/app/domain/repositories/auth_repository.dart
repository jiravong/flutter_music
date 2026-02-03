// Domain contract for authentication-related operations.
//
// Implementations live in the Data layer (e.g. AuthRepositoryImpl).
abstract class AuthRepository {
  // Returns JWT access token on success.
  Future<String> login({required String email, required String password});
}
