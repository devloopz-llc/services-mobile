import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Mirrors the backend's `TradeCategory` schema (`id`, `name`, `slug`) plus
/// the extra display fields the UI needs (subtitle, icon, accent color).
///
/// The trade-categories list isn't exposed as an endpoint yet (see
/// "Known gaps" in the backend's mobile-app-guide) — [defaults] is a
/// stand-in with plausible ids until that endpoint exists, matching the
/// `trade_category_id=1` convention used in the backend's own examples.
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  static List<ServiceCategory> defaults(AppColors colors) => [
        ServiceCategory(
          id: 1,
          title: 'Plumbing',
          subtitle: 'Leaks, repairs & installations',
          icon: Icons.plumbing_rounded,
          color: colors.categoryBlue,
        ),
        ServiceCategory(
          id: 2,
          title: 'Electrical',
          subtitle: 'Faults, sockets & lighting',
          icon: Icons.bolt_rounded,
          color: colors.categoryAmber,
        ),
        ServiceCategory(
          id: 3,
          title: 'Heating',
          subtitle: 'Boilers, radiators & servicing',
          icon: Icons.thermostat_rounded,
          color: colors.categoryGreen,
        ),
        ServiceCategory(
          id: 4,
          title: 'Handyman',
          subtitle: 'Repairs, fixes & assembly',
          icon: Icons.handyman_rounded,
          color: colors.categoryGrey,
        ),
        ServiceCategory(
          id: 5,
          title: 'Locks',
          subtitle: 'Lock repairs, replacements & fitting',
          icon: Icons.lock_outline_rounded,
          color: colors.categoryBlue,
        ),
        ServiceCategory(
          id: 6,
          title: 'Other',
          subtitle: 'Something else not listed here',
          icon: Icons.more_horiz_rounded,
          color: colors.categoryGrey,
        ),
      ];
}
