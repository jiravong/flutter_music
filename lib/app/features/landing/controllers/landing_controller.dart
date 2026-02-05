import 'package:get/get.dart';

// Presentation controller for authentication screen.
//
// Responsibility:
// - Hold UI state (loading/error).
// - Trigger domain use case.
// - Persist token and navigate on success.
class LandingController extends GetxController {
  LandingController();

  // Observable UI state.
  final tabIndex = 0.obs;

  changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
