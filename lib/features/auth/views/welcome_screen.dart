import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/misc/icon_text_row.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(Icons.verified_user_rounded, size: 44, color: colors.success),
              ),
              const SizedBox(height: 24),
              Text(
                'Trusted help\nfor your home',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Reliable professionals. Quality work. Total peace of mind.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              IconTextRow(
                icon: Icons.shield_rounded,
                iconBackground: colors.successContainer,
                iconColor: colors.success,
                title: 'Verified local professionals',
                subtitle: 'Background checked, insured and rated by customers like you.',
              ),
              const SizedBox(height: 18),
              IconTextRow(
                icon: Icons.calendar_month_rounded,
                iconBackground: colors.successContainer,
                iconColor: colors.success,
                title: 'Easy booking',
                subtitle: 'Choose a time that works for you and get the job done.',
              ),
              const SizedBox(height: 18),
              IconTextRow(
                icon: Icons.credit_card_rounded,
                iconBackground: colors.successContainer,
                iconColor: colors.success,
                title: 'Secure payments',
                subtitle: 'Pay safely in-app when the job is complete.',
              ),
              const Spacer(flex: 3),
              AppButton(
                label: 'Get started',
                onPressed: () => Get.toNamed(AppRoutes.createAccount),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'I already have an account',
                variant: AppButtonVariant.outline,
                onPressed: () => Get.toNamed(AppRoutes.login),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'Your data is secure and never shared.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
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
