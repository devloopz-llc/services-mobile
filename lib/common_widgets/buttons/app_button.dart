import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../feedback/app_loading_indicator.dart';

enum AppButtonVariant { primary, secondary, outline }

/// Single reusable CTA button used across the app.
///
/// Visual style stays on-brand on both platforms, but the *feel* of the
/// tap is platform-native: Android gets Material's ripple via
/// [ElevatedButton]/[OutlinedButton], iOS gets Cupertino's opacity-fade
/// via [CupertinoButton] — matching how each OS actually behaves.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onPressed == null || isLoading;

    final Color background;
    final Color foreground;
    final BorderSide? border;
    switch (variant) {
      case AppButtonVariant.primary:
        background = scheme.primary;
        foreground = scheme.onPrimary;
        border = null;
      case AppButtonVariant.secondary:
        background = scheme.secondaryContainer;
        foreground = scheme.onSecondaryContainer;
        border = null;
      case AppButtonVariant.outline:
        background = Colors.transparent;
        foreground = scheme.onSurface;
        border = BorderSide(color: scheme.outline);
    }

    final child = isLoading
        ? AppLoadingIndicator(color: foreground, size: 20)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 18, color: foreground), const SizedBox(width: 8)],
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: foreground),
              ),
            ],
          );

    final Widget button = _isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: disabled ? null : onPressed,
            child: Container(
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: disabled ? background.withValues(alpha: 0.4) : background,
                borderRadius: BorderRadius.circular(14),
                border: border != null ? Border.fromBorderSide(border) : null,
              ),
              child: child,
            ),
          )
        : SizedBox(
            height: 52,
            child: variant == AppButtonVariant.outline
                ? OutlinedButton(onPressed: disabled ? null : onPressed, child: child)
                : ElevatedButton(
                    onPressed: disabled ? null : onPressed,
                    style: ElevatedButton.styleFrom(backgroundColor: background, foregroundColor: foreground),
                    child: child,
                  ),
          );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
