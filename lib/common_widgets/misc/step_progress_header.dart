import 'package:flutter/material.dart';

import '../buttons/circular_icon_button.dart';

/// "Step X of N" header with a segmented progress bar, back button, title
/// and subtitle — the job-report wizard and the quote/payment flow both
/// use this shape.
class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircularIconButton.back(onPressed: onBack),
            const Spacer(),
            Text(
              'Step $currentStep of $totalSteps',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const Spacer(),
            const SizedBox(width: 40),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(totalSteps, (index) {
            final isDone = index < currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
                height: 4,
                decoration: BoxDecoration(
                  color: isDone ? scheme.primary : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
