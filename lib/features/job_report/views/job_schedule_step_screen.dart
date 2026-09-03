import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/cards/address_summary_card.dart';
import '../../../common_widgets/cards/info_banner.dart';
import '../../../common_widgets/cards/selectable_option_card.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/misc/step_progress_header.dart';
import '../../../core/utils/app_date_formatter.dart';
import '../controller/job_report_controller.dart';

class JobScheduleStepScreen extends GetView<JobReportController> {
  const JobScheduleStepScreen({super.key});

  void _openChangeAddressSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change address', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller.addressLineController,
                label: 'Address line',
                onChanged: controller.onAddressLineChanged,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: controller.postcodeController,
                label: 'Postcode',
                onChanged: controller.onPostcodeChanged,
              ),
              const SizedBox(height: 20),
              AppButton(label: 'Save', onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        );
      },
    );
  }

  String _formatSlot(DateTime? start, DateTime? end) {
    if (start == null) return 'Pick a date and time that works for you';
    return '${AppDateFormatter.weekdayDate(start)}, ${AppDateFormatter.time(start)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
                title: 'Where and when?',
                subtitle: 'Add your address and choose urgency.',
              ),
              const SizedBox(height: 20),
              Text('Address', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Obx(
                () => AddressSummaryCard(
                  addressLine: controller.addressLine.value,
                  postcode: controller.postcode.value,
                  onChange: () => _openChangeAddressSheet(context),
                ),
              ),
              const SizedBox(height: 20),
              Text('When do you need help?', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 10),
              Obx(
                () => SelectableOptionCard(
                  icon: Icons.bolt_rounded,
                  title: 'ASAP',
                  subtitle: 'The earliest available slot today',
                  selected: controller.isAsap.value,
                  onTap: controller.selectAsap,
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => SelectableOptionCard(
                  icon: Icons.calendar_month_rounded,
                  title: 'Choose a time',
                  subtitle: _formatSlot(controller.slotStart.value, controller.slotEnd.value),
                  selected: !controller.isAsap.value,
                  onTap: () => controller.pickTime(context),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('This is urgent', style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              "We'll prioritise your request",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Switch(value: controller.isEmergency.value, onChanged: controller.toggleEmergency),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const InfoBanner(
                title: "We'll confirm any charges before work begins",
                variant: InfoBannerVariant.success,
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Review request', onPressed: controller.goToReview),
            ],
          ),
        ),
      ),
    );
  }
}
