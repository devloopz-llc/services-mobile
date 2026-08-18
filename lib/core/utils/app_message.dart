import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

/// Consistent success/error/info toasts for the whole app, driven by the
/// active [ThemeData] so they automatically match light/dark mode.
class AppMessage {
  const AppMessage._();

  static void success(String message) => _show(
        message: message,
        background: (scheme, colors) => colors.success,
        foreground: (scheme, colors) => colors.onSuccess,
        icon: Icons.check_circle_rounded,
      );

  static void error(String message) => _show(
        message: message,
        background: (scheme, _) => scheme.error,
        foreground: (scheme, _) => scheme.onError,
        icon: Icons.error_rounded,
      );

  static void info(String message) => _show(
        message: message,
        background: (scheme, colors) => colors.info,
        foreground: (_, _) => Colors.white,
        icon: Icons.info_rounded,
      );

  static void _show({
    required String message,
    required Color Function(ColorScheme scheme, AppColors colors) background,
    required Color Function(ColorScheme scheme, AppColors colors) foreground,
    required IconData icon,
  }) {
    if (message.trim().isEmpty) return;

    final context = Get.context;
    final scheme = context != null ? Theme.of(context).colorScheme : const ColorScheme.light();
    final appColors = context != null ? Theme.of(context).extension<AppColors>() : null;
    final bg = appColors != null ? background(scheme, appColors) : scheme.primary;
    final fg = appColors != null ? foreground(scheme, appColors) : Colors.white;

    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      messageText: Text(message, style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w500)),
      icon: Icon(icon, color: fg),
      backgroundColor: bg,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
    );
  }
}
