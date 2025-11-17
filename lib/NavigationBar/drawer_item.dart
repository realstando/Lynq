import 'package:flutter/material.dart';

/// A custom drawer item widget that displays an icon, title, and handles tap events.
/// Used in navigation drawers to provide consistent styling across the app.
class DrawerItem extends StatelessWidget {
  DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  /// The background color of the drawer item tile
  Color color;

  /// The icon to display on the left side of the item
  IconData icon;

  /// The text label for the drawer item
  String title;

  /// Callback function triggered when the item is tapped
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add spacing around each drawer item
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        // Icon displayed on the left
        leading: Icon(
          icon,
          color: color,
          size: 26,
        ),
        // Title text displayed next to the icon
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        // Rounded corners for the tile
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Background color of the tile
        tileColor: color,
        // Handle tap events
        onTap: onTap,
      ),
    );
  }
}
