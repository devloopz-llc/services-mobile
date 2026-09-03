import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/app_bar/app_bar_widget.dart';
import '../../../common_widgets/badges/status_badge.dart';
import '../../../common_widgets/cards/technician_card.dart';
import '../../../common_widgets/misc/icon_text_row.dart';
import '../../../common_widgets/misc/vertical_timeline_stepper.dart';
import '../../../core/utils/app_date_formatter.dart';
import '../model/job_booking_summary.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  String _formatWhen(JobBookingSummary summary) {
    if (summary.isAsap || summary.slotStart == null) return 'As soon as possible';
    final date = AppDateFormatter.weekdayDate(summary.slotStart!);
    final start = AppDateFormatter.time(summary.slotStart!);
    final end = summary.slotEnd != null ? AppDateFormatter.time(summary.slotEnd!) : null;
    return end != null ? '$date, $start – $end' : '$date, $start';
  }

  /// The real API only ever returns completed/current timeline steps (see
  /// job-lifecycle.md) — the two steps after "Technician assigned" are
  /// client-side placeholders for what hasn't happened yet, so their state
  /// has to be derived from the booking's current status group rather than
  /// hardcoded, or a completed/past booking would show them as still
  /// pending.
  List<TimelineStep> _buildTimeline(JobBookingSummary summary) {
    final name = summary.technicianName;
    const received = TimelineStep(
      title: 'Received',
      subtitle: 'Your request has been received.',
      state: TimelineStepState.completed,
    );
    final findingProfessional = TimelineStep(
      title: 'Finding a professional',
      subtitle: 'Matched you with $name',
      state: TimelineStepState.completed,
    );

    switch (summary.statusGroup) {
      case AppStatusGroup.confirmed:
        return [
          received,
          findingProfessional,
          TimelineStep(title: 'Technician assigned', subtitle: '$name was assigned to your job.', state: TimelineStepState.completed),
          TimelineStep(title: 'On the way', subtitle: '$name travelled to the property.', state: TimelineStepState.completed),
          const TimelineStep(title: 'Job completed', subtitle: "Work finished — you're all set.", state: TimelineStepState.completed),
        ];
      case AppStatusGroup.live:
        return [
          received,
          findingProfessional,
          TimelineStep(title: 'Technician assigned', subtitle: '$name is assigned to your job.', state: TimelineStepState.completed),
          TimelineStep(title: 'On the way', subtitle: "We'll let you know when $name is on the way.", state: TimelineStepState.current),
          const TimelineStep(title: 'Job completed', subtitle: "You'll be able to review and pay.", state: TimelineStepState.upcoming),
        ];
      default:
        return [
          received,
          findingProfessional,
          TimelineStep(title: 'Technician assigned', subtitle: '$name is assigned to your job.', state: TimelineStepState.current),
          const TimelineStep(title: 'On the way', subtitle: "We'll let you know when your technician is on the way.", state: TimelineStepState.upcoming),
          const TimelineStep(title: 'Job completed', subtitle: "You'll be able to review and pay.", state: TimelineStepState.upcoming),
        ];
    }
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
              StatusBadge(label: summary.statusLabel, group: summary.statusGroup),
              const SizedBox(height: 16),
              TechnicianCard(
                name: summary.technicianName,
                role: summary.technicianRole ?? '${summary.categoryTitle} specialist',
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
              VerticalTimelineStepper(steps: _buildTimeline(summary)),
            ],
          ),
        ),
      ),
    );
  }
}
