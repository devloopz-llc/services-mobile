import 'package:flutter/material.dart';

/// Decorative stand-in for a live map — no maps SDK is wired up yet (needs
/// API keys and a real-location backend neither of which exist), so this
/// draws a stylised route rather than pretending to be interactive.
/// Swap for `google_maps_flutter`/`apple_maps_flutter` once live location
/// is built server-side.
class MapPreviewPlaceholder extends StatelessWidget {
  const MapPreviewPlaceholder({super.key, this.height = 220});

  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: scheme.surfaceContainerHighest),
            CustomPaint(painter: _RoadsPainter(scheme.outline)),
            CustomPaint(painter: _RoutePainter(scheme.primary)),
            const Positioned(left: 24, top: 24, child: _Pin(icon: Icons.person_pin_circle_rounded)),
            const Positioned(right: 28, bottom: 28, child: _Pin(icon: Icons.location_on_rounded)),
          ],
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: scheme.primary,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.25), blurRadius: 6)],
      ),
      child: Icon(icon, color: scheme.onPrimary, size: 20),
    );
  }
}

class _RoadsPainter extends CustomPainter {
  _RoadsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;

    for (final fraction in [0.2, 0.45, 0.7, 0.9]) {
      canvas.drawLine(Offset(0, size.height * fraction), Offset(size.width, size.height * fraction * 0.8), paint);
    }
    for (final fraction in [0.15, 0.5, 0.85]) {
      canvas.drawLine(Offset(size.width * fraction, 0), Offset(size.width * fraction * 0.9, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoadsPainter oldDelegate) => oldDelegate.color != color;
}

class _RoutePainter extends CustomPainter {
  _RoutePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(40, 42)
      ..cubicTo(size.width * 0.3, 60, size.width * 0.4, size.height * 0.5, size.width * 0.65, size.height * 0.6)
      ..cubicTo(size.width * 0.8, size.height * 0.68, size.width * 0.85, size.height * 0.8, size.width - 46, size.height - 46);

    canvas.drawPath(_dashPath(path, 8, 6), paint);
  }

  Path _dashPath(Path source, double dashLength, double gapLength) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLength : gapLength;
        if (draw) {
          dashed.addPath(metric.extractPath(distance, distance + length), Offset.zero);
        }
        distance += length;
        draw = !draw;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => oldDelegate.color != color;
}
