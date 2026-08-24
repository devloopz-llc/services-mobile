import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/inputs/otp_input_field.dart';
import '../../../common_widgets/misc/screen_header.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/verify_otp_controller.dart';

class VerifyNumberScreen extends GetView<VerifyOtpController> {
  const VerifyNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ScreenHeader(
                title: 'Verify your number',
                subtitle: 'Enter the 6-digit code we sent to your mobile number.',
                centered: true,
              ),
              const SizedBox(height: 28),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(color: colors.successContainer, shape: BoxShape.circle),
                child: Icon(Icons.sms_rounded, size: 48, color: colors.success),
              ),
              const SizedBox(height: 24),
              Text(
                'Code sent to',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                controller.phoneNumber.isEmpty ? 'your mobile number' : '🇬🇧 +44 ${controller.phoneNumber}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 28),
              OtpInputField(onChanged: controller.onCodeChanged, onCompleted: controller.onCodeChanged),
              const SizedBox(height: 20),
              Obx(() {
                final seconds = controller.secondsLeft.value;
                if (seconds == 0) {
                  return TextButton(
                    onPressed: controller.resend,
                    child: const Text('Resend code'),
                  );
                }
                return Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    children: [
                      const TextSpan(text: "Didn't receive the code? "),
                      TextSpan(
                        text: 'Resend in ${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(color: colors.success, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
              const Spacer(),
              Obx(
                () => AppButton(
                  label: 'Verify and continue',
                  isLoading: controller.isSubmitting.value,
                  onPressed: controller.verify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
