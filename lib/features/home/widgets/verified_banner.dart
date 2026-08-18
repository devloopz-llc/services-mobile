import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class VerifiedBanner extends StatelessWidget {
  const VerifiedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.successContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: colors.success, shape: BoxShape.circle),
            child: Icon(Icons.check_rounded, color: colors.onSuccess, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verified local professionals',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: colors.onSuccessContainer),
                ),
                const SizedBox(height: 2),
                Text(
                  'Background checked, insured and rated by customers like you.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSuccessContainer.withValues(alpha: 0.85),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
