import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/cards/info_banner.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/inputs/photo_picker_grid.dart';
import '../../../common_widgets/misc/step_progress_header.dart';
import '../controller/job_report_controller.dart';

class JobDetailsStepScreen extends GetView<JobReportController> {
  const JobDetailsStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                title: "Tell us what's happening",
                subtitle: 'The more detail you give, the better we can help.',
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: controller.descriptionController,
                label: 'Describe the issue',
                hint: 'What\'s going on?',
                maxLines: 5,
                maxLength: 500,
              ),
              const SizedBox(height: 12),
              Text('Add photos (optional)', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 10),
              Obx(
                () => PhotoPickerGrid(
                  photos: controller.photos.toList(),
                  onChanged: controller.onPhotosChanged,
                ),
              ),
              const SizedBox(height: 16),
              const InfoBanner(
                title: 'Helpful photos',
                message: 'Include photos of the problem, any error messages, and surrounding area.',
                variant: InfoBannerVariant.success,
                icon: Icons.lightbulb_rounded,
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Continue', onPressed: controller.goToScheduleStep),
            ],
          ),
        ),
      ),
    );
  }
}
