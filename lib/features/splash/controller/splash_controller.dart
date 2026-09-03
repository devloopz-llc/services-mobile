import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final restoring = Get.find<AuthService>().restoreSession();
    // Keep the brand moment on screen for at least this long, however
    // fast the session check resolves.
    final minimumDelay = Future.delayed(const Duration(milliseconds: 1200));

    final results = await Future.wait([restoring, minimumDelay]);
    final isLoggedIn = results[0] as bool;

    Get.offAllNamed(isLoggedIn ? AppRoutes.home : AppRoutes.welcome);
  }
}
