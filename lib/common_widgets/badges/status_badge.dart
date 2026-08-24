import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The backend's six status groups (see `conventions.md` §Enums) — every
/// job/visit/quotation status maps to exactly one of these for colour.
enum AppStatusGroup {
  intake,
  activePipeline,
  awaitingCustomer,
  confirmed,
  live,
  terminalNegative;

  /// Parses the API's snake_case `status_group` value. Unknown values fall
  /// back to [intake] rather than throwing — new statuses should not crash
  /// the app (see conventions.md: "treat as a non-fatal unknown").
  static AppStatusGroup fromApiValue(String value) {
    switch (value) {
      case 'intake':
        return AppStatusGroup.intake;
      case 'active_pipeline':
        return AppStatusGroup.activePipeline;
      case 'awaiting_customer':
        return AppStatusGroup.awaitingCustomer;
      case 'confirmed':
        return AppStatusGroup.confirmed;
      case 'live':
        return AppStatusGroup.live;
      case 'terminal_negative':
        return AppStatusGroup.terminalNegative;
      default:
        return AppStatusGroup.intake;
    }
  }
}

/// Small colored pill for a status label — pass the API's `status_label`
/// as [label] and the parsed [group] for color; never invent display
/// strings for statuses, always show the backend's label as-is.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.group, this.showDot = true});

  final String label;
  final AppStatusGroup group;
  final bool showDot;

  (Color background, Color foreground) _colors(ColorScheme scheme, AppColors colors) {
    switch (group) {
      case AppStatusGroup.intake:
        return (scheme.surfaceContainerHighest, scheme.onSurfaceVariant);
      case AppStatusGroup.activePipeline:
        return (colors.infoContainer, colors.onInfoContainer);
      case AppStatusGroup.awaitingCustomer:
        return (colors.warningContainer, colors.onWarningContainer);
      case AppStatusGroup.confirmed:
        return (colors.successContainer, colors.onSuccessContainer);
      case AppStatusGroup.live:
        return (colors.liveContainer, colors.onLiveContainer);
      case AppStatusGroup.terminalNegative:
        return (scheme.errorContainer, scheme.onErrorContainer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final (background, foreground) = _colors(scheme, colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
