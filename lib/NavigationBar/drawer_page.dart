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
            // Drawer Header - Blue Professional Design
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
              decoration: const BoxDecoration(
                color: Color(0xFF0f172a), // Dark blue-gray background
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF3b82f6), // Blue accent border
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon wrapper with gradient
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3b82f6), // Bright blue
                          Color(0xFF2563eb), // Deeper blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Navigate your experience',
                          style: TextStyle(
                            color: Color(0xFF94a3b8), // Light gray-blue
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
                      Navigator.pop(context);
                      onNavigate(0);
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
                  if (globals.isAdmin == true)
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
