enum MediaType { photo, video }

class MediaItem {
  final String id;
  final MediaType type;

  /// A network URL (seed data) or a local file path (device uploads).
  final String url;

  final String uploaderName;
  final String uploaderInitials;
  final int uploaderColorIndex;
  final DateTime timestamp;
  final String? durationLabel;

  const MediaItem({
    required this.id,
    required this.type,
    required this.url,
    required this.uploaderName,
    required this.uploaderInitials,
    required this.uploaderColorIndex,
    required this.timestamp,
    this.durationLabel,
  });
}
