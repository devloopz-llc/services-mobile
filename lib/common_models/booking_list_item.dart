import 'package:flutter/material.dart';

import '../common_widgets/badges/status_badge.dart';
import '../core/utils/app_date_formatter.dart';

/// A booking as shown in a list row — Home's "current booking" and the
/// Bookings tab both render this shape via `BookingCard`.
class BookingListItem {
  const BookingListItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.statusLabel,
    required this.statusGroup,
    required this.startsAt,
    this.endsAt,
    required this.addressLine,
    required this.technicianName,
    required this.technicianRole,
    this.pricePence,
  });

  final int id;
  final String title;
  final IconData icon;
  final Color iconColor;
  final String statusLabel;
  final AppStatusGroup statusGroup;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String addressLine;
  final String technicianName;
  final String technicianRole;
  final int? pricePence;

  /// "Today, 2:00 pm – 4:00 pm" when it's today and a window is known,
  /// otherwise "Mon, 26 May 2025 at 10:00 am" — matches the backend's own
  /// display convention (see conventions.md §Dates and times).
  String get formattedDateTime {
    final now = DateTime.now();
    final isToday = startsAt.year == now.year && startsAt.month == now.month && startsAt.day == now.day;
    final dayLabel = isToday ? 'Today' : AppDateFormatter.weekdayDate(startsAt);
    final startTime = AppDateFormatter.time(startsAt);
    if (endsAt != null) {
      return '$dayLabel, $startTime – ${AppDateFormatter.time(endsAt!)}';
    }
    return '$dayLabel at $startTime';
  }
}
