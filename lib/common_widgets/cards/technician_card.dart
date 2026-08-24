import 'package:flutter/material.dart';

import '../avatar/app_avatar.dart';
import '../buttons/circular_icon_button.dart';
import '../feedback/app_toast.dart';
import '../misc/rating_stars.dart';

/// Assigned-technician summary — name, role, rating, and Call/Message
/// actions. Used on the booking-detail and technician-tracking screens.
class TechnicianCard extends StatelessWidget {
  const TechnicianCard({
    super.key,
    required this.name,
    required this.role,
    this.rating,
    this.reviewCount,
    this.imageUrl,
    this.onCall,
    this.onMessage,
  });

  final String name;
  final String role;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: name, imageUrl: imageUrl, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleSmall),
                    Text(
                      role,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    if (rating != null) ...[
                      const SizedBox(height: 2),
                      RatingStars(rating: rating!, reviewCount: reviewCount),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: IconLabelButton(
                  icon: Icons.call_rounded,
                  label: 'Call',
                  onPressed: onCall ?? () => AppToast.info('Calling is coming soon.'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: IconLabelButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Message',
                  onPressed: onMessage ?? () => AppToast.info('Messaging is coming soon.'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
