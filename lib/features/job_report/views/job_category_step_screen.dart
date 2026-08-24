import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_models/service_category.dart';
import '../../../common_widgets/cards/service_category_card.dart';
import '../../../common_widgets/inputs/app_text_field.dart';
import '../../../common_widgets/misc/step_progress_header.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/job_report_controller.dart';

class JobCategoryStepScreen extends GetView<JobReportController> {
  const JobCategoryStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categories = ServiceCategory.defaults(context.appColors);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgressHeader(
                currentStep: 1,
                totalSteps: 3,
                title: 'What do you need help with?',
                subtitle: 'Choose a service to get started.',
              ),
              const SizedBox(height: 20),
              AppTextField(
                hint: 'Search for a service',
                prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) => ServiceCategoryCard(
                    category: categories[index],
                    onTap: () => controller.selectCategory(categories[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
