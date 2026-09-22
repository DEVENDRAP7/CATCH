import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/media_item.dart';
import '../models/trip.dart';
import '../theme/app_theme.dart';
import 'dashed_border.dart';
import 'media_thumbnail.dart';

/// The Home-grid "stack of prints" visual: cover photo on top with up to
/// two more photos peeking out beneath it, or a dashed placeholder cell
/// when the trip has no photos yet.
class PhotoStackVisual extends StatelessWidget {
  final Trip trip;

  const PhotoStackVisual({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final cover = trip.coverMedia;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (cover == null)
            _EmptyPlaceholder(icon: trip.icon)
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.maxWidth;
                final others = trip.media.where((m) => m.id != cover.id).take(2).toList();
                final specs = <_LayerSpec>[
                  if (others.length >= 2) _LayerSpec(item: others[1], angle: -9, dx: -0.09, dy: 0.06, darken: true),
                  if (others.isNotEmpty) _LayerSpec(item: others[0], angle: 6, dx: 0.09, dy: 0.06, darken: true),
                  _LayerSpec(item: cover, angle: -2, dx: 0, dy: 0, darken: false),
                ];
                final layerSize = size * 0.84;
                final base = (size - layerSize) / 2;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (var i = 0; i < specs.length; i++)
                      Positioned(
                        left: base + size * specs[i].dx,
                        top: base + size * specs[i].dy,
                        width: layerSize,
                        height: layerSize,
                        child: Transform.rotate(
                          angle: specs[i].angle * math.pi / 180,
                          child: _StackCard(
                            item: specs[i].item,
                            darken: specs[i].darken,
                            elevated: i == specs.length - 1,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          if (trip.itemCount > 0) Positioned(top: -8, right: -8, child: _CountBadge(count: trip.itemCount)),
        ],
      ),
    );
  }
}

class _LayerSpec {
  final MediaItem item;
  final double angle;
  final double dx;
  final double dy;
  final bool darken;

  _LayerSpec({required this.item, required this.angle, required this.dx, required this.dy, required this.darken});
}

class _StackCard extends StatelessWidget {
  final MediaItem item;
  final bool darken;
  final bool elevated;

  const _StackCard({required this.item, required this.darken, required this.elevated});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? const Color(0xFF1C2E2C) : Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(elevated ? 0.24 : 0.14),
            blurRadius: elevated ? 18 : 8,
            offset: Offset(0, elevated ? 10 : 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MediaThumbnail(item: item),
          if (darken) Container(color: Colors.black.withOpacity(0.2)),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.accent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_library_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text('$count', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  final String icon;

  const _EmptyPlaceholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DashedRoundedBorder(
      color: scheme.onSurface.withOpacity(0.25),
      radius: 18,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: scheme.surfaceCard),
        alignment: Alignment.center,
        child: Text(icon, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}
