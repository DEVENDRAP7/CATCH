import 'media_item.dart';

class Trip {
  final String id;
  String name;
  String? description;
  String icon;
  int colorIndex;

  /// User-chosen cover. Falls back to the most recently added item, then to
  /// no cover at all (empty trip) — see [coverMedia].
  String? coverMediaId;

  final List<MediaItem> media;

  Trip({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.colorIndex,
    this.coverMediaId,
    List<MediaItem>? media,
  }) : media = media ?? [];

  MediaItem? get coverMedia {
    final id = coverMediaId;
    if (id != null) {
      final chosen = mediaById(id);
      if (chosen != null) return chosen;
    }
    if (media.isNotEmpty) return media.first;
    return null;
  }

  MediaItem? mediaById(String id) {
    for (final item in media) {
      if (item.id == id) return item;
    }
    return null;
  }

  int get itemCount => media.length;
}
