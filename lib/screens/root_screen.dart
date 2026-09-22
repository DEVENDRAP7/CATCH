import 'package:flutter/material.dart';

import '../widgets/catch_bottom_nav.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Hosts the two-tab bottom nav. Trip Detail, Create Trip, and the Media
/// Viewer are pushed as full-screen routes on top of this, per §2.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onOpenProfile: () => setState(() => _index = 1)),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CatchBottomNav(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}
