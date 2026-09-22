import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/media_item.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/time_ago.dart';
import '../utils/trip_options.dart';
import '../widgets/catch_loading_badge.dart';
import '../widgets/media_image.dart';

class MediaViewerScreen extends StatefulWidget {
  final String tripId;
  final String mediaId;

  const MediaViewerScreen({super.key, required this.tripId, required this.mediaId});

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  VideoPlayerController? _controller;
  bool _requestedInit = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _ensureVideo(MediaItem item) async {
    if (_requestedInit) return;
    _requestedInit = true;
    final controller = item.url.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(item.url))
        : VideoPlayerController.file(File(item.url));
    await controller.initialize();
    await controller.setVolume(0);
    controller.setLooping(true);
    controller.play();
    if (mounted) {
      setState(() => _controller = controller);
    } else {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final trip = state.tripById(widget.tripId);
    final item = trip?.mediaById(widget.mediaId);

    if (trip == null || item == null) {
      return const Scaffold(backgroundColor: Colors.black, body: SizedBox());
    }

    if (item.type == MediaType.video) {
      _ensureVideo(item);
    }

    final isCover = trip.coverMedia?.id == item.id;
    final gradient = tripGradients[item.uploaderColorIndex % tripGradients.length];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: gradient)),
                    alignment: Alignment.center,
                    child: Text(
                      item.uploaderInitials,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.uploaderName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        Text(timeAgo(item.timestamp), style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: item.type == MediaType.video
                    ? _VideoBody(controller: _controller)
                    : InteractiveViewer(maxScale: 4, child: MediaImage(item: item, fit: BoxFit.contain)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: _CoverPillButton(
                isCover: isCover,
                onTap: () => context.read<AppState>().setCover(trip.id, item.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoBody extends StatefulWidget {
  final VideoPlayerController? controller;

  const _VideoBody({required this.controller});

  @override
  State<_VideoBody> createState() => _VideoBodyState();
}

class _VideoBodyState extends State<_VideoBody> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    if (controller == null || !controller.value.isInitialized) {
      return CatchLoadingBadge(size: 48, background: Theme.of(context).colorScheme.accent, blobColor: Colors.white);
    }
    return GestureDetector(
      onTap: () => setState(() {
        controller.value.isPlaying ? controller.pause() : controller.play();
      }),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return AnimatedOpacity(
                  opacity: value.isPlaying ? 0 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverPillButton extends StatelessWidget {
  final bool isCover;
  final VoidCallback onTap;

  const _CoverPillButton({required this.isCover, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sun = Theme.of(context).colorScheme.sun;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: isCover ? sun : Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isCover ? sun : Colors.white.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isCover ? Icons.star_rounded : Icons.star_outline_rounded, color: isCover ? Colors.black87 : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              isCover ? 'Cover photo' : 'Set as cover',
              style: TextStyle(color: isCover ? Colors.black87 : Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
