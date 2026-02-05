import 'package:get/get.dart';

// Presentation controller for authentication screen.
//
// Responsibility:
// - Hold UI state (loading/error).
// - Trigger domain use case.
// - Persist token and navigate on success.
class HomeController extends GetxController {
  HomeController();

  // Observable UI state.
  final isLoading = false.obs;
  final errorMessage = ''.obs;
}
