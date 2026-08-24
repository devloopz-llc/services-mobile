import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/misc/screen_header.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/login_controller.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'Welcome back', subtitle: 'Sign in to continue.'),
              const SizedBox(height: 24),
              AppTextField(
                controller: controller.emailController,
                label: 'Email address',
                hint: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.mail_outline_rounded, color: scheme.onSurfaceVariant),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Obx(
                () => AppTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: controller.obscurePassword.value,
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: scheme.onSurfaceVariant),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                    onPressed: controller.toggleObscurePassword,
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.forgotPassword,
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => AppButton(
                  label: 'Sign in',
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.submit,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider(color: scheme.outline)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or continue with',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                  Expanded(child: Divider(color: scheme.outline)),
                ],
              ),
              const SizedBox(height: 20),
              const SocialLoginButton(provider: SocialProvider.apple),
              const SizedBox(height: 12),
              const SocialLoginButton(provider: SocialProvider.google),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.createAccount),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
