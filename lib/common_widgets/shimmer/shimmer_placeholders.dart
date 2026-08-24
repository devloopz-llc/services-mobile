import 'package:flutter/material.dart';

import 'shimmer_box.dart';

/// Skeleton for a list row with a leading avatar/icon — conversation lists,
/// notification lists, booking lists.
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key, this.leadingSize = 44});

  final double leadingSize;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerCircle(size: leadingSize),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 160, height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(width: 100, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for a bordered content card — service category cards, booking
/// cards, quote summaries.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.height = 96});

  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppShimmer(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            ShimmerCircle(size: 36),
            ShimmerBox(width: 100, height: 14),
            ShimmerBox(width: 140, height: 11),
          ],
        ),
      ),
    );
  }
}

/// Repeats [ShimmerListTile] `count` times — drop straight into a `ListView`
/// while data is loading.
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => const ShimmerListTile(),
      ),
    );
  }
}
