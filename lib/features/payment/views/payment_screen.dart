import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/misc/step_progress_header.dart';
import '../../../core/utils/money_formatter.dart';
import '../../technician_tracking/controller/service_visit_controller.dart';

class PaymentScreen extends GetView<ServiceVisitController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = controller.quotation.totalPence;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgressHeader(
                currentStep: 3,
                totalSteps: 3,
                title: 'Pay securely',
                subtitle: 'Enter your payment details to complete your booking.',
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: controller.cardNumberController,
                label: 'Card number',
                hint: '4242 4242 4242 4242',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                prefixIcon: Icon(Icons.credit_card_rounded, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: controller.expiryController,
                      label: 'Expiry date',
                      hint: 'MM / YY',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: controller.cvcController,
                      label: 'CVC',
                      hint: '123',
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller.cardholderNameController,
                label: 'Cardholder name',
                hint: 'Name on card',
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, color: Colors.white, size: 22),
                    SizedBox(width: 6),
                    Text('Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Quote total', style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Text(MoneyFormatter.gbp(total), style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Text('Total to pay', style: Theme.of(context).textTheme.titleSmall)),
                        Text(MoneyFormatter.gbp(total), style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => AppButton(
                  label: 'Pay ${MoneyFormatter.gbp(total)}',
                  icon: Icons.lock_rounded,
                  isLoading: controller.isProcessingPayment.value,
                  onPressed: controller.pay,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'Payments are encrypted.',
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
