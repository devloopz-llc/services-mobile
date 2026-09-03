import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/misc/screen_header.dart';
import '../controller/register_controller.dart';
import '../widgets/password_requirement_checklist.dart';
import '../widgets/social_login_button.dart';
import '../widgets/terms_checkbox_row.dart';
import '../widgets/uk_phone_field.dart';

class CreateAccountScreen extends GetView<RegisterController> {
  const CreateAccountScreen({super.key});

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
              const ScreenHeader(title: 'Create your account', subtitle: "Let's get you set up."),
              const SizedBox(height: 24),
              AppTextField(
                controller: controller.nameController,
                label: 'Full name',
                hint: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline_rounded, color: scheme.onSurfaceVariant),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller.emailController,
                label: 'Email address',
                hint: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.mail_outline_rounded, color: scheme.onSurfaceVariant),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              UkPhoneField(controller: controller.phoneController),
              const SizedBox(height: 16),
              Obx(
                () => AppTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  hint: 'Create a secure password',
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
                  onChanged: controller.onPasswordChanged,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => PasswordRequirementChecklist(password: controller.password.value)),
              const SizedBox(height: 16),
              Obx(
                () => TermsCheckboxRow(
                  value: controller.agreedToTerms.value,
                  onChanged: (value) => controller.agreedToTerms.value = value,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => AppButton(
                  label: 'Create account',
                  isLoading: controller.isLoading.value,
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
            ],
          ),
        ),
      ),
    );
  }
}
