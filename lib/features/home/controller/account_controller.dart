import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

class AccountController extends GetxController {
  AuthService get authService => Get.find<AuthService>();

  void openComingSoon(String label) => AppToast.info('$label is coming soon.');

  Future<void> confirmLogout(BuildContext context) async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Log out?'),
        content: const Text("You'll need to sign in again to book or track a job."),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Log out', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authService.logout();
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
