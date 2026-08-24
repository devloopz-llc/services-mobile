import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mobile number field with a fixed "+44" prefix — the backend is a
/// UK-only business (see conventions.md: postcodes, GBP-only money), so a
/// full country picker would be a feature the rest of the app never uses.
class UkPhoneField extends StatelessWidget {
  const UkPhoneField({super.key, required this.controller, this.label = 'Mobile number'});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('🇬🇧 +44', style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d ]'))],
                decoration: const InputDecoration(hintText: '7700 900123'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
