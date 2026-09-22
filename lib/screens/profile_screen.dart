import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trip.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/trip_options.dart';
import 'trip_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final user = state.currentUser;
    final gradient = tripGradients[user.colorIndex % tripGradients.length];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user.initials,
                      style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(user.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('Trip organizer', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Trips', value: '${state.trips.length}')),
                const SizedBox(width: 14),
                Expanded(child: _StatCard(label: 'Memories', value: '${state.totalMemories}')),
              ],
            ),
            const SizedBox(height: 28),
            Text('Your trips', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (state.trips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('No trips yet.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5))),
              )
            else
              ...state.trips.map(
                (trip) => _TripRow(
                  trip: trip,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceCard, borderRadius: BorderRadius.circular(18)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.accent)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65))),
        ],
      ),
    );
  }
}

class _TripRow extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const _TripRow({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = tripGradients[trip.colorIndex % tripGradients.length];
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              alignment: Alignment.center,
              child: Text(trip.icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  Text(
                    trip.itemCount == 0 ? 'No photos yet' : '${trip.itemCount} photos',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}
