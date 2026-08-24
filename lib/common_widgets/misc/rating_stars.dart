import 'package:flutter/material.dart';

/// Read-only star rating — technician cards, review summaries.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14,
    this.maxStars = 5,
  });

  final double rating;
  final int? reviewCount;
  final double starSize;
  final int maxStars;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxStars, (index) {
          final threshold = index + 1;
          IconData icon;
          if (rating >= threshold) {
            icon = Icons.star_rounded;
          } else if (rating >= threshold - 0.5) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_border_rounded;
          }
          return Icon(icon, size: starSize, color: Colors.amber);
        }),
        if (reviewCount != null) ...[
          const SizedBox(width: 6),
          Text(
            '$rating ($reviewCount reviews)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
