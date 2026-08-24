import 'dart:io';

import 'package:flutter/material.dart';

import '../models/media_item.dart';
import '../theme/app_theme.dart';
import 'catch_loading_badge.dart';

/// Renders a photo [MediaItem] from either a network URL (seed data) or a
/// local file path (device uploads).
class MediaImage extends StatelessWidget {
  final MediaItem item;
  final BoxFit fit;

  const MediaImage({super.key, required this.item, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (item.url.startsWith('http')) {
      return Image.network(
        item.url,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(context),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: scheme.surfaceCard,
            alignment: Alignment.center,
            child: CatchLoadingBadge(size: 32, background: scheme.accent, blobColor: Colors.white),
          );
        },
      );
    }
    return Image.file(File(item.url), fit: fit, errorBuilder: (_, __, ___) => _fallback(context));
  }

  Widget _fallback(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceCard,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported_outlined, color: scheme.onSurface.withOpacity(0.4)),
    );
  }
}
