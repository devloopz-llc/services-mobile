import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/cards/quotation_summary_card.dart';
import '../../../common_widgets/cards/reference_code_card.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/misc/icon_text_row.dart';
import '../../../common_widgets/misc/step_progress_header.dart';
import '../../technician_tracking/controller/service_visit_controller.dart';

class QuotationScreen extends GetView<ServiceVisitController> {
  const QuotationScreen({super.key});

  void _openDeclineSheet(BuildContext context) {
    final reasonController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Decline this quote?', style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                "Let us know why, if you'd like — it's optional and helps us send a better price next time.",
                style: Theme.of(sheetContext)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(sheetContext).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: reasonController,
                hint: 'We had a cheaper quote elsewhere (optional)',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Decline quote',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  controller.declineQuote(reasonController.text.trim().isEmpty ? null : reasonController.text.trim());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quotation = controller.quotation;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgressHeader(
                currentStep: 2,
                totalSteps: 3,
                title: 'Your quotation',
                subtitle: 'Please review your quote details.',
              ),
              const SizedBox(height: 20),
              const ReferenceCodeCard(label: 'Reference', code: 'Q-2405167', trailingLabel: 'Valid until 28 May'),
              const SizedBox(height: 16),
              QuotationSummaryCard(quotation: quotation),
              const SizedBox(height: 20),
              const IconTextRow(
                icon: Icons.verified_rounded,
                title: 'All work is guaranteed for 12 months.',
              ),
              const SizedBox(height: 14),
              const IconTextRow(
                icon: Icons.info_outline_rounded,
                title: 'Payment is only taken once the work is completed to your satisfaction.',
              ),
              const SizedBox(height: 24),
              Obx(
                () => AppButton(
                  label: 'Approve quote',
                  isLoading: controller.isSubmittingQuoteDecision.value,
                  onPressed: controller.approveQuote,
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Decline',
                variant: AppButtonVariant.outline,
                onPressed: () => _openDeclineSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
