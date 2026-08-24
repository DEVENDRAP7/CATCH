import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Plays a brief scale+fade pop the first time it mounts. Keying a tile by
/// its item id means a freshly-inserted item naturally mounts (and pops)
/// the moment it appears, with no manual "is this new" bookkeeping needed.
class PopIn extends StatefulWidget {
  final Widget child;

  const PopIn({super.key, required this.child});

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final reduceMotion = SchedulerBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 260),
    );
    _scale = Tween(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacity = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
