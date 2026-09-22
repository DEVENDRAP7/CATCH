import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'photo_stack.dart';
import 'pressable_scale.dart';

/// A single Home-grid cell: the photo stack, trip name, and photo count.
class TripStackCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripStackCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressableScale(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoStackVisual(trip: trip),
          const SizedBox(height: 12),
          Text(
            trip.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            trip.itemCount == 0 ? 'No photos yet' : '${trip.itemCount} photos',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
