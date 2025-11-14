import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/drawer_item.dart';

class DrawerPage extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final void Function(int) onNavigate;

  const DrawerPage({
    super.key,
    required this.icon,
    required this.name,
    required this.color,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Navigate your experience',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context); // Close drawer first
                      onNavigate(0); // Then navigate
                    },
                    color: color,
                  ),
                  DrawerItem(
                    icon: Icons.campaign_rounded,
                    title: 'Announcements',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(1);
                    },
                    color: color,
                  ),
                  DrawerItem(
                    icon: Icons.event_rounded,
                    title: 'Events',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(2);
                    },
                    color: color,
                  ),

                  DrawerItem(
                    icon: Icons.calendar_today_rounded,
                    title: 'Calendar',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(3);
                    },
                    color: color,
                  ),
                  DrawerItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Resources',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(4);
                    },
                    color: color,
                  ),
                  DrawerItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Groups',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(6);
                    },
                    color: color,
                  ),
                  DrawerItem(
                    icon: Icons.mobile_friendly_rounded,
                    title: 'Social Media',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(7);
                    },
                    color: color,
                  ),
                  if (globals.isAdmin!)
                    DrawerItem(
                      icon: Icons.lock_rounded,
                      title: 'Admin',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(10);
                      },
                      color: color,
                    ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Divider(color: Colors.grey[300]),
                  ListTile(
                    leading: Icon(
                      Icons.person_rounded,
                      color: Colors.grey[600],
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(5);
                    },
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
