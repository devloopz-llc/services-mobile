import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// "I agree to the Terms & Conditions and Privacy Policy" row with tappable
/// links. [onTermsTap]/[onPrivacyTap] are optional — wire them up once
/// those documents have somewhere to open to.
class TermsCheckboxRow extends StatelessWidget {
  const TermsCheckboxRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bodyStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);
    final linkStyle = bodyStyle?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (checked) => onChanged(checked ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text.rich(
              TextSpan(
                style: bodyStyle,
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: linkStyle,
                    recognizer: onTermsTap != null ? (TapGestureRecognizer()..onTap = onTermsTap) : null,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: linkStyle,
                    recognizer: onPrivacyTap != null ? (TapGestureRecognizer()..onTap = onPrivacyTap) : null,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
