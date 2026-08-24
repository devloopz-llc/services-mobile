import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../feedback/app_toast.dart';

/// Tinted box showing a reference/quote code with a copy button — "Request
/// received" and "Your quotation" both show one of these.
class ReferenceCodeCard extends StatelessWidget {
  const ReferenceCodeCard({super.key, required this.label, required this.code, this.trailingLabel});

  final String label;
  final String code;

  /// e.g. "Valid until 28 May" shown on the right for quotes.
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.description_rounded, color: scheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                ),
                Row(
                  children: [
                    Text(
                      code,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: scheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: code));
                        AppToast.success('Copied to clipboard.');
                      },
                      child: Icon(Icons.copy_rounded, size: 16, color: scheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (trailingLabel != null)
            Text(
              trailingLabel!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
            ),
        ],
      ),
    );
  }
}
