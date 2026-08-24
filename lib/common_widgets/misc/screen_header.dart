import 'package:flutter/material.dart';

import '../buttons/circular_icon_button.dart';

/// Back button + title + subtitle header for screens that don't carry a
/// step progress bar (auth screens, confirmation screens). For the
/// multi-step wizards, use [StepProgressHeader] instead.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.centered = false,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final crossAxis = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        if (showBackButton) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: CircularIconButton.back(onPressed: onBack),
          ),
          const SizedBox(height: 20),
        ],
        Text(title, textAlign: textAlign, style: Theme.of(context).textTheme.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
