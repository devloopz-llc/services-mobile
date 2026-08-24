import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Placeholder for real startup work (auth check, remote config, etc).
    await Future.delayed(const Duration(milliseconds: 1600));
    Get.offAllNamed(AppRoutes.welcome);
  }
}
