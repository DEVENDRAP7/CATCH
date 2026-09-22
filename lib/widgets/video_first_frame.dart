import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../theme/app_theme.dart';
import 'catch_loading_badge.dart';

/// Shows a video's first frame (paused, muted) as a thumbnail. Used for
/// video tiles in the trip grid and inside the photo-stack visual.
class VideoFirstFrame extends StatefulWidget {
  final String url;

  const VideoFirstFrame({super.key, required this.url});

  @override
  State<VideoFirstFrame> createState() => _VideoFirstFrameState();
}

class _VideoFirstFrameState extends State<VideoFirstFrame> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final controller = widget.url.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
          : VideoPlayerController.file(File(widget.url));
      await controller.initialize();
      await controller.setVolume(0);
      await controller.pause();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: scheme.surfaceCard,
        alignment: Alignment.center,
        child: _failed
            ? Icon(Icons.videocam_off_outlined, color: scheme.onSurface.withOpacity(0.4))
            : CatchLoadingBadge(size: 28, background: scheme.accent, blobColor: Colors.white),
      );
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}
