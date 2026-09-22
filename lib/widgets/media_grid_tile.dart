import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/media_item.dart';
import '../models/trip.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/time_ago.dart';
import '../utils/trip_options.dart';
import 'media_thumbnail.dart';

/// A single Trip Detail grid tile: thumbnail, cover-picker star, video play
/// badge, and the uploader attribution chip.
class MediaGridTile extends StatelessWidget {
  final Trip trip;
  final MediaItem item;
  final VoidCallback onTap;

  const MediaGridTile({super.key, required this.trip, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCover = trip.coverMedia?.id == item.id;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MediaThumbnail(item: item),
          if (item.type == MediaType.video) const Positioned(top: 6, right: 6, child: _PlayBadge()),
          Positioned(
            top: 6,
            left: 6,
            child: _CoverStarButton(
              filled: isCover,
              onTap: () => context.read<AppState>().setCover(trip.id, item.id),
            ),
          ),
          Positioned(left: 6, bottom: 6, child: UploaderChip(item: item)),
        ],
      ),
    );
  }
}

class _PlayBadge extends StatelessWidget {
  const _PlayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.5)),
      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
    );
  }
}

class _CoverStarButton extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;

  const _CoverStarButton({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(shape: BoxShape.circle, color: filled ? scheme.sun : Colors.black.withOpacity(0.35)),
        child: Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: filled ? Colors.black87 : Colors.white,
          size: 16,
        ),
      ),
    );
  }
}

/// Small pill showing the uploader's mini avatar, first name, and relative
/// time — the only attribution shown on a tile.
class UploaderChip extends StatelessWidget {
  final MediaItem item;

  const UploaderChip({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final gradient = tripGradients[item.uploaderColorIndex % tripGradients.length];
    final firstName = item.uploaderName.split(' ').first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: gradient)),
            alignment: Alignment.center,
            child: Text(
              item.uploaderInitials,
              style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$firstName · ${timeAgo(item.timestamp)}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
