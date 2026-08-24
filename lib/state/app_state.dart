import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/media_item.dart';
import '../models/trip.dart';

class AppUser {
  final String name;
  final String initials;
  final int colorIndex;

  const AppUser({required this.name, required this.initials, required this.colorIndex});
}

class AppState extends ChangeNotifier {
  AppState() {
    _seed();
  }

  final AppUser currentUser = const AppUser(name: 'You', initials: 'Y', colorIndex: 0);

  final List<Trip> _trips = [];
  List<Trip> get trips => List.unmodifiable(_trips);

  int get totalMemories => _trips.fold(0, (sum, trip) => sum + trip.itemCount);

  Trip? tripById(String id) {
    for (final trip in _trips) {
      if (trip.id == id) return trip;
    }
    return null;
  }

  Trip addTrip({
    required String name,
    String? description,
    required String icon,
    required int colorIndex,
  }) {
    final trimmedDescription = description?.trim();
    final trip = Trip(
      id: _newId(),
      name: name.trim(),
      description: (trimmedDescription == null || trimmedDescription.isEmpty) ? null : trimmedDescription,
      icon: icon,
      colorIndex: colorIndex,
    );
    _trips.insert(0, trip);
    notifyListeners();
    return trip;
  }

  void setCover(String tripId, String mediaId) {
    final trip = tripById(tripId);
    if (trip == null) return;
    trip.coverMediaId = mediaId;
    notifyListeners();
  }

  void addMedia(String tripId, MediaItem item) {
    final trip = tripById(tripId);
    if (trip == null) return;
    trip.media.insert(0, item);
    notifyListeners();
  }

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999)}';

  void _seed() {
    final now = DateTime.now();

    final bali = Trip(
      id: _newId(),
      name: 'Bali Adventure',
      description: 'Ten days of waterfalls, temples, and sunset surf sessions.',
      icon: '🌴',
      colorIndex: 0,
      media: [
        MediaItem(
          id: _newId(),
          type: MediaType.photo,
          url: 'https://picsum.photos/seed/bali5/900/900',
          uploaderName: 'You',
          uploaderInitials: 'Y',
          uploaderColorIndex: 0,
          timestamp: now.subtract(const Duration(minutes: 20)),
        ),
        MediaItem(
          id: _newId(),
          type: MediaType.video,
          url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          uploaderName: 'Jordan Lee',
          uploaderInitials: 'JL',
          uploaderColorIndex: 3,
          timestamp: now.subtract(const Duration(hours: 2)),
          durationLabel: '0:32',
        ),
        MediaItem(
          id: _newId(),
          type: MediaType.photo,
          url: 'https://picsum.photos/seed/bali4/900/900',
          uploaderName: 'Maya Chen',
          uploaderInitials: 'MC',
          uploaderColorIndex: 1,
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
        MediaItem(
          id: _newId(),
          type: MediaType.photo,
          url: 'https://picsum.photos/seed/bali3/900/900',
          uploaderName: 'Maya Chen',
          uploaderInitials: 'MC',
          uploaderColorIndex: 1,
          timestamp: now.subtract(const Duration(hours: 26)),
        ),
        MediaItem(
          id: _newId(),
          type: MediaType.photo,
          url: 'https://picsum.photos/seed/bali2/900/900',
          uploaderName: 'Jordan Lee',
          uploaderInitials: 'JL',
          uploaderColorIndex: 3,
          timestamp: now.subtract(const Duration(days: 2)),
        ),
      ],
    );

    final mountains = Trip(
      id: _newId(),
      name: 'Mountain Retreat',
      description: 'A long weekend in the Rockies with the whole crew.',
      icon: '⛰️',
      colorIndex: 2,
      media: [
        MediaItem(
          id: _newId(),
          type: MediaType.photo,
          url: 'https://picsum.photos/seed/peak1/900/900',
          uploaderName: 'Sam Rivera',
          uploaderInitials: 'SR',
          uploaderColorIndex: 4,
          timestamp: now.subtract(const Duration(days: 4)),
        ),
        MediaItem(
          id: _newId(),
          type: MediaType.photo,
          url: 'https://picsum.photos/seed/peak2/900/900',
          uploaderName: 'You',
          uploaderInitials: 'Y',
          uploaderColorIndex: 0,
          timestamp: now.subtract(const Duration(days: 5)),
        ),
      ],
    );

    final weekend = Trip(
      id: _newId(),
      name: 'Weekend Getaway',
      icon: '🏕️',
      colorIndex: 4,
    );

    _trips.addAll([bali, mountains, weekend]);
  }
}
