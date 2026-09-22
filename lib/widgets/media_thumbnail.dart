import 'package:flutter/material.dart';

import '../models/media_item.dart';
import 'media_image.dart';
import 'video_first_frame.dart';

/// Picks the right renderer for a grid/stack tile: a photo image, or a
/// video's first frame.
class MediaThumbnail extends StatelessWidget {
  final MediaItem item;
  final BoxFit fit;

  const MediaThumbnail({super.key, required this.item, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (item.type == MediaType.video) {
      return VideoFirstFrame(url: item.url);
    }
    return MediaImage(item: item, fit: fit);
  }
}
