import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable_scale.dart';

/// The single coral-gradient circular FAB used for both trip creation
/// (Home) and media upload (Trip Detail).
class GradientFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GradientFab({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? [AppColors.coralDark, const Color(0xFFFFA98F)]
        : [AppColors.coralLight, const Color(0xFFFF8F73)];

    return PressableScale(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(color: colors.first.withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
