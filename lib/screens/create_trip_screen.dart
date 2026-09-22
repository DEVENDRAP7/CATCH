import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/trip_options.dart';
import '../widgets/shake_widget.dart';
import 'trip_detail_screen.dart';

/// Only reachable from the Home "+" FAB. On success, navigates straight
/// into the new (empty) Trip Detail screen.
class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  int _iconIndex = 0;
  int _colorIndex = 0;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _shakeKey.currentState?.shake();
      setState(() => _nameError = 'Give your trip a name');
      return;
    }
    final trip = context.read<AppState>().addTrip(
          name: name,
          description: _descController.text,
          icon: tripIcons[_iconIndex],
          colorIndex: _colorIndex,
        );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TripDetailScreen(tripId: trip.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = tripGradients[_colorIndex % tripGradients.length];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      'New trip',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                children: [
                  Center(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                          ),
                          alignment: Alignment.center,
                          child: Text(tripIcons[_iconIndex], style: const TextStyle(fontSize: 36)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'This is how your trip will look on Home',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  ShakeWidget(
                    key: _shakeKey,
                    child: TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: 'Trip name', errorText: _nameError),
                      onChanged: (_) {
                        if (_nameError != null) setState(() => _nameError = null);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                    maxLength: 120,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Description (optional)'),
                  ),
                  const SizedBox(height: 12),
                  Text('Icon', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var i = 0; i < tripIcons.length; i++)
                        _IconChoice(emoji: tripIcons[i], selected: i == _iconIndex, onTap: () => setState(() => _iconIndex = i)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Color', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (var i = 0; i < tripGradients.length; i++)
                        _ColorChoice(colors: tripGradients[i], selected: i == _colorIndex, onTap: () => setState(() => _colorIndex = i)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('Create trip'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _IconChoice({required this.emoji, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? scheme.accent.withOpacity(0.16) : scheme.surfaceCard,
          border: Border.all(color: selected ? scheme.accent : Colors.transparent, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  final List<Color> colors;
  final bool selected;
  final VoidCallback onTap;

  const _ColorChoice({required this.colors, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: selected ? Colors.white : Colors.transparent, width: 3),
          boxShadow: selected ? [BoxShadow(color: colors.first.withOpacity(0.5), blurRadius: 10)] : null,
        ),
        alignment: Alignment.center,
        child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
      ),
    );
  }
}
