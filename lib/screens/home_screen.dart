import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_fab.dart';
import '../widgets/trip_stack_card.dart';
import 'create_trip_screen.dart';
import 'trip_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenProfile;

  const HomeScreen({super.key, required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    final trips = context.watch<AppState>().trips;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: trips.isEmpty
            ? _EmptyHome(onOpenProfile: onOpenProfile)
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _HomeHeader(onOpenProfile: onOpenProfile)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 26,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.76,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final trip = trips[index];
                          return TripStackCard(
                            trip: trip,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)),
                            ),
                          );
                        },
                        childCount: trips.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: trips.isEmpty
          ? null
          : GradientFab(
              icon: Icons.add_rounded,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateTripScreen(), fullscreenDialog: true),
              ),
            ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onOpenProfile;

  const _HomeHeader({required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: scheme.coral, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Text('📸', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 10),
          Text('Catch', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(
            onPressed: onOpenProfile,
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: scheme.accent.withOpacity(0.16),
              child: Icon(Icons.person_rounded, color: scheme.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  final VoidCallback onOpenProfile;

  const _EmptyHome({required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _HomeHeader(onOpenProfile: onOpenProfile),
        Expanded(
          child: Center(
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
                    child: const Text('🧳', style: TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(height: 20),
                  Text('No trips yet', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    'Start a trip to collect every photo and video from the group in one place.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.65)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateTripScreen(), fullscreenDialog: true),
                    ),
                    child: const Text('Create your first trip'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
