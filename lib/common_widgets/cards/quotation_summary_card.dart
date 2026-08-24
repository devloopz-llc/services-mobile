import 'package:flutter/material.dart';

import '../../core/utils/money_formatter.dart';
import '../../features/quote/model/quotation.dart';

/// Line items + VAT + total, formatted from integer pence — never
/// calculate VAT client-side, the API always sends it pre-computed (see
/// conventions.md §Money).
class QuotationSummaryCard extends StatelessWidget {
  const QuotationSummaryCard({super.key, required this.quotation});

  final Quotation quotation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
          for (final item in quotation.lineItems)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(child: Text(item.typeLabel, style: textTheme.bodyMedium)),
                  Text(
                    MoneyFormatter.gbp(item.totalPence),
                    style: textTheme.bodyMedium?.copyWith(
                      color: item.totalPence < 0 ? scheme.error : scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          Divider(color: scheme.outline),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  'VAT (${quotation.vatRatePercent.toStringAsFixed(0)}%)',
                  style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
              Text(
                MoneyFormatter.gbp(quotation.vatPence),
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text('Total', style: textTheme.titleMedium)),
              Text(MoneyFormatter.gbp(quotation.totalPence), style: textTheme.titleMedium),
            ],
          ),
          if (quotation.isEstimate) ...[
            const SizedBox(height: 10),
            Text(
              'This is an estimate — the final bill follows the hours actually worked.',
              style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
