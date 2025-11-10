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
      toolbarHeight: 120,
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.1),
      scrolledUnderElevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, size: 28),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                letterSpacing: 0.5,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 300,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, size: 40),
          tooltip: 'Profile',
          onPressed:
              onProfileTap ??
              () {
                onNavigate(5); // Navigate to profile page
              },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
