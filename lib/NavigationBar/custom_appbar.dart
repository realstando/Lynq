import 'package:flutter/material.dart';
import 'package:coding_prog/profile/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String name;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onProfileTap;
  final void Function(int) onNavigate;

  CustomAppBar({
    super.key,
    required this.name,
    required this.color,
    required this.scaffoldKey,
    required this.onNavigate,
    this.onProfileTap,
  });

  Color _darkenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  Color _accentColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    final accent = hsl.withSaturation((hsl.saturation + 0.1).clamp(0.0, 1.0));
    return accent.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final Color darkColor = _darkenColor(color, 0.15);
    final Color accentColor = _accentColor(color);

    return AppBar(
      toolbarHeight: 80,
      backgroundColor: color,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.3),
      scrolledUnderElevation: 4,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, darkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, size: 28, color: Colors.white),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
            tooltip: 'Profile',
            onPressed:
                onProfileTap ??
                () {
                  onNavigate(5);
                },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
