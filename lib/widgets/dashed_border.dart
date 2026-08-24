import 'package:flutter/material.dart';

/// Paints a dashed rounded-rect outline on top of [child]. Used for the
/// empty-trip placeholder stack cell.
class DashedRoundedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;

  const DashedRoundedBorder({
    super.key,
    required this.child,
    required this.color,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedPainter(color: color, radius: radius),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final dashed = _dashPath(path, dashArray: const [7, 6]);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(dashed, paint);
  }

  Path _dashPath(Path source, {required List<double> dashArray}) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var drawing = true;
      var i = 0;
      while (distance < metric.length) {
        final len = dashArray[i % dashArray.length];
        if (drawing) {
          dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        drawing = !drawing;
        i++;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
