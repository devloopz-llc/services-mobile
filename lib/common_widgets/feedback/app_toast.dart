import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

enum _ToastKind { success, error, info, warning }

/// Custom top-of-screen toast — deliberately not the default Material/GetX
/// snackbar look. Slides down, auto-dismisses, swipe-up to dismiss early.
/// Colors follow the active theme (light/dark) automatically.
class AppToast {
  const AppToast._();

  static OverlayEntry? _current;

  static void success(String message, {String? title}) =>
      _show(_ToastKind.success, message, title: title, icon: Icons.check_circle_rounded);

  static void error(String message, {String? title}) =>
      _show(_ToastKind.error, message, title: title, icon: Icons.error_rounded);

  static void warning(String message, {String? title}) =>
      _show(_ToastKind.warning, message, title: title, icon: Icons.warning_rounded);

  static void info(String message, {String? title}) =>
      _show(_ToastKind.info, message, title: title, icon: Icons.info_rounded);

  static void _show(_ToastKind kind, String message, {String? title, required IconData icon}) {
    if (message.trim().isEmpty) return;
    final overlayContext = Get.overlayContext;
    if (overlayContext == null) return;
    final overlay = Overlay.of(overlayContext, rootOverlay: true);

    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastCard(
        kind: kind,
        title: title,
        message: message,
        icon: icon,
        onDismissed: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({
    required this.kind,
    required this.message,
    required this.icon,
    required this.onDismissed,
    this.title,
  });

  final _ToastKind kind;
  final String? title;
  final String message;
  final IconData icon;
  final VoidCallback onDismissed;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    reverseDuration: const Duration(milliseconds: 180),
  );
  late final Animation<Offset> _slide = Tween(
    begin: const Offset(0, -0.4),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 3400), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (Color background, Color foreground, Color accent) _colors(ColorScheme scheme, AppColors colors) {
    switch (widget.kind) {
      case _ToastKind.success:
        return (colors.successContainer, colors.onSuccessContainer, colors.success);
      case _ToastKind.error:
        return (scheme.errorContainer, scheme.onErrorContainer, scheme.error);
      case _ToastKind.warning:
        return (colors.warningContainer, colors.onWarningContainer, colors.warning);
      case _ToastKind.info:
        return (colors.infoContainer, colors.onInfoContainer, colors.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final (background, foreground, accent) = _colors(scheme, colors);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _controller,
          child: Material(
            color: Colors.transparent,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onDismissed(),
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border(left: BorderSide(color: accent, width: 4)),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                        child: Icon(widget.icon, color: scheme.surface, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null)
                              Text(
                                widget.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: foreground),
                              ),
                            Text(
                              widget.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: foreground),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
