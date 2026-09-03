import 'package:flutter/material.dart';

import '../../common_models/booking_list_item.dart';
import '../../core/utils/money_formatter.dart';
import '../avatar/app_avatar.dart';
import '../badges/status_badge.dart';

/// Full booking summary row — Home's "current booking" and every row in
/// the Bookings tab. Pass [onViewDetails] to show the "View details" link;
/// omit it to keep the card display-only.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, this.onViewDetails});

  final BookingListItem booking;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onViewDetails,
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: booking.iconColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(booking.icon, color: booking.iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(booking.title, style: textTheme.titleSmall)),
                StatusBadge(label: booking.statusLabel, group: booking.statusGroup),
              ],
            ),
            const SizedBox(height: 12),
            _IconLine(icon: Icons.calendar_today_rounded, text: booking.formattedDateTime),
            const SizedBox(height: 6),
            _IconLine(icon: Icons.location_on_outlined, text: booking.addressLine),
            const SizedBox(height: 12),
            Row(
              children: [
                AppAvatar(name: booking.technicianName, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.technicianName, style: textTheme.bodyMedium),
                      Text(
                        booking.technicianRole,
                        style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (booking.pricePence != null)
                  Text(MoneyFormatter.gbp(booking.pricePence!), style: textTheme.titleSmall),
              ],
            ),
            if (onViewDetails != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('View details', style: textTheme.labelLarge?.copyWith(color: scheme.primary)),
                  Icon(Icons.chevron_right_rounded, size: 18, color: scheme.primary),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
