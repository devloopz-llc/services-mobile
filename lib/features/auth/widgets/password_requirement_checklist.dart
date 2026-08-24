import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PasswordRequirement {
  const PasswordRequirement(this.label, this.isMet);

  final String label;
  final bool isMet;
}

/// Live checklist under the password field — matches Laravel's default
/// rule set (8+ characters) plus the two extra rules the design calls out.
class PasswordRequirementChecklist extends StatelessWidget {
  const PasswordRequirementChecklist({super.key, required this.password});

  final String password;

  List<PasswordRequirement> get _requirements => [
        PasswordRequirement('At least 8 characters', password.length >= 8),
        PasswordRequirement('Include a number', RegExp(r'\d').hasMatch(password)),
        PasswordRequirement('Include an uppercase letter', RegExp(r'[A-Z]').hasMatch(password)),
      ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _requirements
          .map(
            (requirement) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    requirement.isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
                    size: 15,
                    color: requirement.isMet ? colors.success : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    requirement.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: requirement.isMet ? colors.success : scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
