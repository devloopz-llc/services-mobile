import 'package:flutter/material.dart';

/// Pill-style segmented control — "Upcoming / Past" and similar two-or-more
/// way local filters.
class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({super.key, required this.labels, required this.selectedIndex, required this.onChanged});

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? scheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [BoxShadow(color: scheme.shadow.withValues(alpha: 0.12), blurRadius: 6)]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
