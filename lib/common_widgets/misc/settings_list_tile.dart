import 'package:flutter/material.dart';

/// Icon + label + chevron row for a settings/menu screen. Set
/// [isDestructive] for actions like "Log out" (red, no chevron).
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isDestructive ? scheme.error : scheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDestructive ? scheme.error : scheme.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color))),
            if (!isDestructive) Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Card wrapper that lays out a divider between each [SettingsListTile].
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, this.title, required this.tiles});

  final String? title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(title!, style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                tiles[i],
                if (i != tiles.length - 1) Divider(height: 1, color: scheme.outline),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
