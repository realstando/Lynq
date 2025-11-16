import 'package:flutter/material.dart';

/// A custom filter chip widget with selection state and count badge
/// Features dynamic theming based on selection state and category color
/// Used for filtering content by category (e.g., event types, post categories)
/// Displays an icon, label, and item count in a compact, tappable chip
class CustomFilterChip extends StatelessWidget {
  /// The text label displayed on the chip
  final String label;

  /// The number of items in this category
  /// Displayed in a small badge next to the label
  final int count;

  /// Whether this chip is currently selected/active
  /// Controls styling and color scheme (inverted colors when selected)
  final bool isSelected;

  /// The theme color for this chip
  /// Used for icon, text, and background depending on selection state
  final Color color;

  /// The icon displayed on the left side of the chip
  /// Provides visual identification for the category
  final IconData icon;

  /// Callback function executed when the chip is tapped
  /// Typically used to toggle filter state or update selection
  final VoidCallback onTap;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Handle tap to toggle selection
      borderRadius: BorderRadius.circular(
        12,
      ), // Match container radius for ripple
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          // Background color: category color when selected, white when not
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Border: prominent when selected, subtle when not
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.3),
            width: 2,
          ),
          // Shadow: only shown when selected for elevated appearance
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(
                      0.3,
                    ), // Tinted shadow matches category
                    blurRadius: 8,
                    offset: Offset(0, 2), // Slight downward shadow
                  ),
                ]
              : [], // No shadow when unselected (flat appearance)
        ),
        // Horizontal layout: [Icon] [Label] [Count Badge]
        child: Row(
          mainAxisSize: MainAxisSize.min, // Shrink to fit content
          children: [
            // Category icon with inverted colors based on selection
            Icon(
              icon,
              size: 18,
              // White when selected (on colored background)
              // Colored when unselected (on white background)
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8), // Space between icon and label
            // Category label text
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color, // Inverted coloring
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5, // Slight spacing for emphasis
              ),
            ),
            const SizedBox(width: 6), // Space between label and count
            // Count badge - small pill showing number of items
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                // Semi-transparent background for contrast
                color: isSelected
                    ? Colors.white.withOpacity(
                        0.25,
                      ) // Light on colored background
                    : color.withOpacity(0.15), // Tinted on white background
                borderRadius: BorderRadius.circular(10), // Pill shape
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11, // Smaller than label text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
