import 'package:flutter/material.dart';

/// Address line + postcode with a "Change" action — the job-report wizard
/// and the review screen both show this for the same address.
class AddressSummaryCard extends StatelessWidget {
  const AddressSummaryCard({
    super.key,
    required this.addressLine,
    required this.postcode,
    this.onChange,
  });

  final String addressLine;
  final String postcode;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, color: scheme.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressLine, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  postcode,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (onChange != null)
            TextButton(onPressed: onChange, child: const Text('Change')),
        ],
      ),
    );
  }
}
