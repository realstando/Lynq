import 'package:flutter/material.dart';

/// Reusable custom action button widget with FBLA branding
/// Displays a navy blue button with gold icon and white text
/// Commonly used for "Add" or "Create" actions throughout the app
class CustomActionButton extends StatelessWidget {
  const CustomActionButton({
    super.key,
    required this.openAddPage,
    required this.name,
    required this.icon,
  });

  /// Callback function executed when button is tapped
  final void Function() openAddPage;

  /// Text label displayed on the button (e.g., "Add Event", "New Resource")
  final String name;

  /// Icon displayed to the left of the text
  final IconData icon;

  // FBLA brand colors - consistent across the app
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  @override
  Widget build(context) {
    return Padding(
      // Bottom and right padding to prevent button from touching screen edges
      padding: EdgeInsets.only(bottom: 20, right: 8),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: fblaNavy, // Navy blue background
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Material(
          color: Colors.transparent,
          // InkWell provides the ripple effect when button is tapped
          child: InkWell(
            onTap: () {
              openAddPage(); // Execute the provided callback
            },
            borderRadius: BorderRadius.circular(
              12,
            ), // Match container border radius for ripple
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Button width fits content
                children: [
                  // Gold icon on the left
                  Icon(
                    icon,
                    color: fblaGold,
                    size: 24,
                  ),
                  SizedBox(width: 12), // Spacing between icon and text
                  // White text label
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing:
                          0.5, // Slightly spaced letters for readability
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
