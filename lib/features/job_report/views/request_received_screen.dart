import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/buttons/app_button.dart';
import '../../../common_widgets/cards/reference_code_card.dart';
import '../../../common_widgets/misc/icon_text_row.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../model/job_booking_summary.dart';

class RequestReceivedScreen extends StatefulWidget {
  const RequestReceivedScreen({super.key});

  @override
  State<RequestReceivedScreen> createState() => _RequestReceivedScreenState();
}

class _RequestReceivedScreenState extends State<RequestReceivedScreen> {
  bool _notifyMe = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final summary = Get.arguments as JobBookingSummary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: colors.successContainer, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, size: 44, color: colors.success),
              ),
              const SizedBox(height: 20),
              Text('Request received', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(
                "Thank you! We've received your request.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ReferenceCodeCard(label: 'Your booking reference', code: summary.referenceCode),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('What happens next?', style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(height: 14),
              IconTextRow(
                icon: Icons.search_rounded,
                iconBackground: colors.successContainer,
                iconColor: colors.success,
                title: 'We review your request',
                subtitle: 'Within a few minutes',
              ),
              const SizedBox(height: 16),
              IconTextRow(
                icon: Icons.groups_rounded,
                iconBackground: colors.successContainer,
                iconColor: colors.success,
                title: 'We find the right professional',
                subtitle: summary.isAsap ? 'Usually within 30 minutes' : 'Ahead of your chosen time',
              ),
              const SizedBox(height: 16),
              IconTextRow(
                icon: Icons.event_available_rounded,
                iconBackground: colors.successContainer,
                iconColor: colors.success,
                title: "You'll get a confirmation",
                subtitle: 'With date, time and details',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_none_rounded, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stay updated', style: Theme.of(context).textTheme.bodyMedium),
                          Text(
                            "We'll notify you about important updates.",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Switch(value: _notifyMe, onChanged: (value) => setState(() => _notifyMe = value)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'View booking',
                onPressed: () async {
                  await Get.offAllNamed(AppRoutes.home);
                  Get.toNamed(AppRoutes.bookingDetail, arguments: summary);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
