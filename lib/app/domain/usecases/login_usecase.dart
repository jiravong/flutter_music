import '../repositories/auth_repository.dart';

// Use case that performs login via AuthRepository.
//
// Presentation layer calls this (through a controller) to keep UI independent
// from repository implementation.
class LoginUseCase {
  LoginUseCase(this._repo);

  final AuthRepository _repo;

  // Executes the login action and returns a JWT access token.
  Future<String> call({required String email, required String password}) {
    return _repo.login(email: email, password: password);
  }
}
