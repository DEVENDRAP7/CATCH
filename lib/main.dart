import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/root_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CatchApp());
}

class CatchApp extends StatelessWidget {
  const CatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Catch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const RootScreen(),
      ),
    );
  }
}
