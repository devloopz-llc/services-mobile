import 'package:flutter/material.dart';

/// Section title with a trailing "View all" style link — used above list
/// previews (conversations, notifications) that link to a fuller list.
class SectionHeaderWithAction extends StatelessWidget {
  const SectionHeaderWithAction({super.key, required this.title, this.actionLabel = 'View all', this.onAction});

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        if (onAction != null)
          InkWell(
            onTap: onAction,
            child: Row(
              children: [
                Text(actionLabel, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.primary)),
                Icon(Icons.chevron_right_rounded, size: 18, color: scheme.primary),
              ],
            ),
          ),
      ],
    );
  }
}
