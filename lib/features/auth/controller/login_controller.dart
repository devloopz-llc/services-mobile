import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../model/app_user.dart';

class LoginController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void toggleObscurePassword() => obscurePassword.value = !obscurePassword.value;

  Future<void> submit() async {
    if (!_emailPattern.hasMatch(emailController.text.trim())) {
      AppToast.error('Enter a valid email address.');
      return;
    }
    if (passwordController.text.isEmpty) {
      AppToast.error('Enter your password.');
      return;
    }

    final authService = Get.find<AuthService>();
    final session = await callApi(
      () => authService.login(email: emailController.text.trim(), password: passwordController.text),
    );
    if (session == null) return;

    if (session.user.role != UserRole.customer) {
      await authService.logout();
      AppToast.error('This app is for customers. Technicians should use the technician app.');
      return;
    }

    Get.offAllNamed(AppRoutes.home);
  }

  void forgotPassword() => AppToast.info('Password reset is coming soon.');

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
