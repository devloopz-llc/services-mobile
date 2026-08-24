import 'package:flutter/material.dart';

enum TimelineStepState { completed, current, upcoming }

class TimelineStep {
  const TimelineStep({required this.title, this.subtitle, required this.state});

  final String title;
  final String? subtitle;
  final TimelineStepState state;
}

/// Vertical progress timeline — mirrors the shape of the backend's job
/// `timeline` array (`status_label` + `at`, oldest first), extended with
/// client-side "upcoming" steps for the parts of the journey that haven't
/// happened yet (the real API only ever returns completed/current steps).
class VerticalTimelineStepper extends StatelessWidget {
  const VerticalTimelineStepper({super.key, required this.steps});

  final List<TimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) _StepRow(step: steps[i], isLast: i == steps.length - 1),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});

  final TimelineStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUpcoming = step.state == TimelineStepState.upcoming;
    final indicatorColor = isUpcoming ? scheme.surfaceContainerHighest : scheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
                child: Icon(
                  step.state == TimelineStepState.completed ? Icons.check_rounded : Icons.circle,
                  size: step.state == TimelineStepState.completed ? 16 : 10,
                  color: isUpcoming ? scheme.onSurfaceVariant : scheme.onPrimary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: isUpcoming ? scheme.outline : scheme.primary),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isUpcoming ? scheme.onSurfaceVariant : scheme.onSurface,
                        ),
                  ),
                  if (step.subtitle != null)
                    Text(
                      step.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
