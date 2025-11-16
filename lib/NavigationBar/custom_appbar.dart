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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: const Color(
        0xFF0f172a,
      ), // Dark blue-gray to match drawer
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.3),
      scrolledUnderElevation: 4,
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
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3b82f6), // Bright blue
                    Color(0xFF2563eb), // Deeper blue
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
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
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3b82f6),
                    Color(0xFF2563eb),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
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
                  onNavigate(5); // Navigate to profile page
                },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
