import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum InfoBannerVariant { success, info, warning, error }

/// Rounded, tinted banner for a short reassurance/warning message with an
/// icon badge — "Verified local professionals", "We'll confirm any charges
/// before work begins", payment/security notices, and similar.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.variant = InfoBannerVariant.info,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final InfoBannerVariant variant;

  (Color container, Color onContainer, Color accent, IconData defaultIcon) _style(
    ColorScheme scheme,
    AppColors colors,
  ) {
    switch (variant) {
      case InfoBannerVariant.success:
        return (colors.successContainer, colors.onSuccessContainer, colors.success, Icons.check_rounded);
      case InfoBannerVariant.info:
        return (colors.infoContainer, colors.onInfoContainer, colors.info, Icons.info_rounded);
      case InfoBannerVariant.warning:
        return (colors.warningContainer, colors.onWarningContainer, colors.warning, Icons.warning_rounded);
      case InfoBannerVariant.error:
        return (scheme.errorContainer, scheme.onErrorContainer, scheme.error, Icons.error_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final (container, onContainer, accent, defaultIcon) = _style(scheme, colors);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: container, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            child: Icon(icon ?? defaultIcon, color: scheme.surface, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: onContainer)),
                if (message != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: onContainer.withValues(alpha: 0.85)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
