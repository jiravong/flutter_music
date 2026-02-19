import 'package:get/get.dart';

// Bindings are GetX's dependency injection entry point for a route.
//
// This binding wires the full dependency chain for the login feature:
// GetStorage -> TokenStorage -> ApiClient -> AuthRepository -> LoginUseCase -> AuthController
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController, AuthRepository, LoginUseCase are registered as permanent
    // in InitialBinding so they survive route lifecycle changes.
  }
}
