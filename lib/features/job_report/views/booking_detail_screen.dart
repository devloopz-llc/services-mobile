import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/app_bar/app_bar_widget.dart';
import '../../../common_widgets/badges/status_badge.dart';
import '../../../common_widgets/cards/technician_card.dart';
import '../../../common_widgets/misc/icon_text_row.dart';
import '../../../common_widgets/misc/vertical_timeline_stepper.dart';
import '../model/job_booking_summary.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  String _formatWhen(JobBookingSummary summary) {
    if (summary.isAsap || summary.slotStart == null) return 'As soon as possible';
    final date = DateFormat('EEE, d MMM').format(summary.slotStart!);
    final start = DateFormat('h:mm a').format(summary.slotStart!);
    final end = summary.slotEnd != null ? DateFormat('h:mm a').format(summary.slotEnd!) : null;
    return end != null ? '$date, $start – $end' : '$date, $start';
  }

  @override
  Widget build(BuildContext context) {
    final summary = Get.arguments as JobBookingSummary;

    return Scaffold(
      appBar: const AppBarWidget(title: 'Your booking'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusBadge(label: 'Technician assigned', group: AppStatusGroup.activePipeline),
              const SizedBox(height: 16),
              TechnicianCard(
                name: 'Amir K.',
                role: '${summary.categoryTitle} specialist',
                rating: 4.9,
                reviewCount: 128,
              ),
              const SizedBox(height: 16),
              IconTextRow(
                icon: Icons.calendar_today_rounded,
                title: _formatWhen(summary),
                subtitle: 'Estimated arrival window',
              ),
              const SizedBox(height: 16),
              IconTextRow(
                icon: Icons.location_on_rounded,
                title: summary.addressLine,
                subtitle: 'At the property',
              ),
              const SizedBox(height: 24),
              Text('Progress', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 16),
              VerticalTimelineStepper(
                steps: const [
                  TimelineStep(title: 'Received', subtitle: 'Your request has been received.', state: TimelineStepState.completed),
                  TimelineStep(title: "Finding a professional", subtitle: 'Matching you with a trusted technician.', state: TimelineStepState.completed),
                  TimelineStep(title: 'Technician assigned', subtitle: 'Amir K. is assigned to your job.', state: TimelineStepState.current),
                  TimelineStep(title: 'On the way', subtitle: "We'll let you know when Amir is on the way.", state: TimelineStepState.upcoming),
                  TimelineStep(title: 'Job completed', subtitle: "You'll be able to review and pay.", state: TimelineStepState.upcoming),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
