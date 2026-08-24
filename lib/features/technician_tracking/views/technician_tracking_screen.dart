import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/avatar/app_avatar.dart';
import '../../../common_widgets/badges/status_badge.dart';
import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/buttons/circular_icon_button.dart';
import '../../../common_widgets/cards/info_banner.dart';
import '../../../common_widgets/feedback/app_toast.dart';
import '../../../common_widgets/misc/map_preview_placeholder.dart';
import '../../../common_widgets/misc/rating_stars.dart';
import '../../../common_widgets/misc/step_progress_header.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/service_visit_controller.dart';

class TechnicianTrackingScreen extends GetView<ServiceVisitController> {
  const TechnicianTrackingScreen({super.key});

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
                currentStep: 1,
                totalSteps: 3,
                title: 'Your technician',
                subtitle: "We'll let you know when your technician is on the way.",
              ),
              const SizedBox(height: 20),
              const MapPreviewPlaceholder(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${controller.etaMinutes.value} min', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              'estimated arrival',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        AppAvatar(name: controller.technicianName, size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.technicianName, style: Theme.of(context).textTheme.titleSmall),
                              Text(
                                controller.technicianRole,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 2),
                              RatingStars(rating: controller.rating),
                            ],
                          ),
                        ),
                        Obx(
                          () => StatusBadge(label: controller.technicianStatus.value, group: AppStatusGroup.live),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: IconLabelButton(
                            icon: Icons.call_rounded,
                            label: 'Call',
                            onPressed: () => AppToast.info('Calling is coming soon.'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: IconLabelButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Message',
                            onPressed: () => AppToast.info('Messaging is coming soon.'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const InfoBanner(
                title: 'Location is shared only while travelling to your job.',
                variant: InfoBannerVariant.info,
                icon: Icons.shield_rounded,
              ),
              const SizedBox(height: 24),
              AppButton(label: 'View quote', onPressed: () => Get.toNamed(AppRoutes.quotation)),
            ],
          ),
        ),
      ),
    );
  }
}
