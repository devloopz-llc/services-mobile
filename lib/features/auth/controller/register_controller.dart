import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/routes/app_routes.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final password = ''.obs;
  final agreedToTerms = false.obs;
  final isSubmitting = false.obs;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void onPasswordChanged(String value) => password.value = value;

  void toggleObscurePassword() => obscurePassword.value = !obscurePassword.value;

  Future<void> submit() async {
    if (nameController.text.trim().isEmpty) {
      AppToast.error('Enter your full name.');
      return;
    }
    if (!_emailPattern.hasMatch(emailController.text.trim())) {
      AppToast.error('Enter a valid email address.');
      return;
    }
    if (phoneController.text.trim().length < 9) {
      AppToast.error('Enter a valid mobile number.');
      return;
    }
    final meetsPasswordRules = passwordController.text.length >= 8 &&
        RegExp(r'\d').hasMatch(passwordController.text) &&
        RegExp(r'[A-Z]').hasMatch(passwordController.text);
    if (!meetsPasswordRules) {
      AppToast.error('Your password needs to meet all the requirements below.');
      return;
    }
    if (!agreedToTerms.value) {
      AppToast.error('Please agree to the Terms & Conditions to continue.');
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSubmitting.value = false;
    Get.toNamed(AppRoutes.verifyNumber, arguments: phoneController.text.trim());
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
