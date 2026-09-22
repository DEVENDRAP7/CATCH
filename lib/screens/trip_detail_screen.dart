import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/media_item.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/trip_options.dart';
import '../widgets/gradient_fab.dart';
import '../widgets/media_grid_tile.dart';
import '../widgets/pop_in.dart';
import 'media_viewer_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _uploading = false;
  double _progress = 0;
  MediaType _uploadingType = MediaType.photo;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _openPicker() async {
    final choice = await showModalBottomSheet<MediaType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _MediaTypeSheet(),
    );
    if (choice == null) return;
    await _pick(choice);
  }

  Future<void> _pick(MediaType type) async {
    final picker = ImagePicker();
    final XFile? file = type == MediaType.photo
        ? await picker.pickImage(source: ImageSource.gallery, imageQuality: 90)
        : await picker.pickVideo(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    _simulateUpload(file, type);
  }

  void _simulateUpload(XFile file, MediaType type) {
    _timer?.cancel();
    setState(() {
      _uploading = true;
      _progress = 0;
      _uploadingType = type;
    });
    const steps = 22;
    var step = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 55), (t) {
      step++;
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _progress = (step / steps).clamp(0, 1));
      if (step >= steps) {
        t.cancel();
        _finishUpload(file, type);
      }
    });
  }

  void _finishUpload(XFile file, MediaType type) {
    final state = context.read<AppState>();
    final user = state.currentUser;
    state.addMedia(
      widget.tripId,
      MediaItem(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        type: type,
        url: file.path,
        uploaderName: user.name,
        uploaderInitials: user.initials,
        uploaderColorIndex: user.colorIndex,
        timestamp: DateTime.now(),
      ),
    );
    if (mounted) setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<AppState>().tripById(widget.tripId);
    final theme = Theme.of(context);

    if (trip == null) {
      return const Scaffold(body: SizedBox());
    }

    final gradient = tripGradients[trip.colorIndex % tripGradients.length];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    alignment: Alignment.center,
                    child: Text(trip.icon, style: const TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                        if (trip.description != null && trip.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            trip.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_uploading) _UploadBanner(progress: _progress, type: _uploadingType),
            Expanded(
              child: trip.media.isEmpty
                  ? _EmptyTrip(onAddPhoto: () => _pick(MediaType.photo))
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 110),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 1,
                      ),
                      itemCount: trip.media.length,
                      itemBuilder: (context, index) {
                        final item = trip.media[index];
                        return PopIn(
                          key: ValueKey(item.id),
                          child: MediaGridTile(
                            trip: trip,
                            item: item,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => MediaViewerScreen(tripId: trip.id, mediaId: item.id)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: GradientFab(icon: Icons.camera_alt_rounded, onTap: _openPicker),
    );
  }
}

class _UploadBanner extends StatelessWidget {
  final double progress;
  final MediaType type;

  const _UploadBanner({required this.progress, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = type == MediaType.photo ? 'Uploading photo…' : 'Uploading video…';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: theme.colorScheme.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
              Text('${(progress * 100).round()}%', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.accent.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTrip extends StatelessWidget {
  final VoidCallback onAddPhoto;

  const _EmptyTrip({required this.onAddPhoto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: theme.colorScheme.coral.withOpacity(0.14), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(Icons.camera_alt_rounded, size: 36, color: theme.colorScheme.coral),
            ),
            const SizedBox(height: 20),
            Text('No memories yet', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Add the first photo from this trip to start the stack.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onAddPhoto, child: const Text('Add first photo')),
          ],
        ),
      ),
    );
  }
}

class _MediaTypeSheet extends StatelessWidget {
  const _MediaTypeSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_outlined),
              title: const Text('Photo'),
              onTap: () => Navigator.of(context).pop(MediaType.photo),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Video'),
              onTap: () => Navigator.of(context).pop(MediaType.video),
            ),
          ],
        ),
      ),
    );
  }
}
