import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Catch's branded loading indicator: a soft blob shape that continuously
/// morphs between a many-pointed flower and a rounded 4-lobed blob while
/// slowly rotating, inside a solid accent-colored circle.
class CatchLoadingBadge extends StatefulWidget {
  final double size;
  final Color background;
  final Color blobColor;

  const CatchLoadingBadge({
    super.key,
    this.size = 48,
    required this.background,
    required this.blobColor,
  });

  @override
  State<CatchLoadingBadge> createState() => _CatchLoadingBadgeState();
}

class _CatchLoadingBadgeState extends State<CatchLoadingBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final reduceMotion = SchedulerBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
    if (reduceMotion) {
      _controller.value = 0.25;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.background),
      padding: EdgeInsets.all(widget.size * 0.24),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _BlobPainter(t: _controller.value, color: widget.blobColor),
        ),
      ),
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

class _BlobPainter extends CustomPainter {
  final double t;
  final Color color;

  _BlobPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final base = size.shortestSide / 2;
    const points = 48;
    final morph = (math.sin(t * 2 * math.pi) + 1) / 2;
    final lobes = _lerp(9, 4, morph);
    final amplitude = _lerp(base * 0.24, base * 0.15, morph);
    final rotation = t * 2 * math.pi * 0.5;

    final path = Path();
    for (var i = 0; i <= points; i++) {
      final theta = (i / points) * 2 * math.pi;
      final r = base * 0.62 + amplitude * math.cos(lobes * theta);
      final x = center.dx + r * math.cos(theta + rotation);
      final y = center.dy + r * math.sin(theta + rotation);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) => oldDelegate.t != t || oldDelegate.color != color;
}
