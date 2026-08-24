import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Floating circular icon button — the back button used over hero
/// imagery/colored headers instead of the standard [AppBar] leading icon,
/// plus Call/Message action pairs.
class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.background,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? background;
  final Color? iconColor;

  factory CircularIconButton.back({VoidCallback? onPressed, double size = 40}) {
    final isIOS = !kIsWeb && Platform.isIOS;
    return CircularIconButton(
      icon: isIOS ? CupertinoIcons.back : Icons.arrow_back_rounded,
      onPressed: onPressed,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: background ?? scheme.surface,
      shape: const CircleBorder(),
      elevation: 1,
      shadowColor: scheme.shadow.withValues(alpha: 0.2),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: size * 0.45, color: iconColor ?? scheme.onSurface),
        ),
      ),
    );
  }
}

/// Compact pill button with a leading icon — "Call" / "Message" actions
/// next to a technician's contact card.
class IconLabelButton extends StatelessWidget {
  const IconLabelButton({super.key, required this.icon, required this.label, this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: scheme.outline),
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
