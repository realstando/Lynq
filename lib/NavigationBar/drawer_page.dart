import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/drawer_item.dart';

/// Stateless widget that displays the navigation drawer
/// Provides access to all major sections of the app with a professional design
class DrawerPage extends StatelessWidget {
  /// Icon to display in the drawer header
  final IconData icon;

  /// Name/title to display in the drawer header
  final String name;

  /// Accent color for active navigation items
  final Color color;

  /// Callback function to handle navigation to different pages
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
            // Drawer Header - Professional blue design with gradient icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
              decoration: const BoxDecoration(
                color: Color(0xFF0f172a), // Dark blue-gray background
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF3b82f6), // Blue accent border at bottom
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container with gradient background
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
                  // Header text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main title (e.g., "Instagram", "Home", etc.)
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
                        // Subtitle text
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

            // Navigation Items List - Scrollable list of all app sections
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  // Home navigation item
                  DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      onNavigate(0); // Navigate to home (index 0)
                    },
                    color: color,
                  ),
                  // Announcements navigation item
                  DrawerItem(
                    icon: Icons.campaign_rounded,
                    title: 'Announcements',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(1); // Navigate to announcements (index 1)
                    },
                    color: color,
                  ),
                  // Events navigation item
                  DrawerItem(
                    icon: Icons.event_rounded,
                    title: 'Events',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(2); // Navigate to events (index 2)
                    },
                    color: color,
                  ),
                  // Calendar navigation item
                  DrawerItem(
                    icon: Icons.calendar_today_rounded,
                    title: 'Calendar',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(3); // Navigate to calendar (index 3)
                    },
                    color: color,
                  ),
                  // Resources navigation item
                  DrawerItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Resources',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(4); // Navigate to resources (index 4)
                    },
                    color: color,
                  ),
                  // Groups navigation item
                  DrawerItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Groups',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(6); // Navigate to groups (index 6)
                    },
                    color: color,
                  ),
                  // Social Media navigation item
                  DrawerItem(
                    icon: Icons.mobile_friendly_rounded,
                    title: 'Social Media',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(7); // Navigate to social media (index 7)
                    },
                    color: color,
                  ),
                  // Admin navigation item - only shown if user is an admin
                  if (globals.isAdmin == true)
                    DrawerItem(
                      icon: Icons.lock_rounded,
                      title: 'Admin',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(10); // Navigate to admin panel (index 10)
                      },
                      color: color,
                    ),
                ],
              ),
            ),

            // Footer section with Profile link
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Divider line separating navigation from footer
                  Divider(color: Colors.grey[300]),
                  // Profile navigation item
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
                      onNavigate(5); // Navigate to profile (index 5)
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
