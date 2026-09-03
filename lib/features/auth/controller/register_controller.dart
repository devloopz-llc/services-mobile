import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/app_toast.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../model/app_user.dart';

/// Registers a customer account. Note there's no OTP step behind
/// "Verify your number" — the real `/auth/register` returns a token
/// immediately — so this goes straight to Home on success rather than
/// routing through that screen.
class RegisterController extends BaseController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final password = ''.obs;
  final agreedToTerms = false.obs;

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

    final authService = Get.find<AuthService>();
    final session = await callApi(
      () => authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
      ),
    );
    if (session == null) return;

    if (session.user.role != UserRole.customer) {
      await authService.logout();
      AppToast.error('This app is for customers. Technicians should use the technician app.');
      return;
    }

    Get.offAllNamed(AppRoutes.home);
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
