import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });
  Color color;
  IconData icon;
  String title;
  VoidCallback onTap;
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: color,
        onTap: onTap,
      ),
    );
  }
}
