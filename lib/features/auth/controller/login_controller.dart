import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isSubmitting = false.obs;

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

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSubmitting.value = false;
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
