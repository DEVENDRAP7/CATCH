import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class _NavEntry {
  final IconData icon;
  final String label;

  const _NavEntry(this.icon, this.label);
}

/// Floating pill-shaped bottom navigation: a rounded dark/light bar with a
/// margin from the screen edges, where the selected tab grows into an
/// accent-colored horizontal capsule (icon + label inline) and unselected
/// tabs sit as plain icon-over-label.
class CatchBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const CatchBottomNav({super.key, required this.index, required this.onChanged});

  static const _items = [
    _NavEntry(Icons.home_rounded, 'Home'),
    _NavEntry(Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: scheme.navBackground,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(scheme.brightness == Brightness.dark ? 0.4 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: _NavItem(
                  icon: _items[i].icon,
                  label: _items[i].label,
                  selected: index == i,
                  reduceMotion: reduceMotion,
                  onTap: () => onChanged(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool reduceMotion;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.reduceMotion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withOpacity(0.45);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? scheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: selected
              ? Row(
                  key: const ValueKey('selected'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('unselected'),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: muted, size: 22),
                    const SizedBox(height: 3),
                    Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w600, fontSize: 11)),
                  ],
                ),
        ),
      ),
    );
  }
}
