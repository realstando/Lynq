import 'package:flutter/material.dart';

/// A custom AppBar widget designed for social media applications.
///
/// This widget provides a styled app bar with:
/// - A back navigation button
/// - A centered title with custom styling
/// - A colored decorative line below the title
/// - A profile button for user account access
///
/// The app bar has an increased height (120) to accommodate the custom layout.
class SocialMediaAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// The name/title to display in the center of the app bar
  final String name;

  /// The color used for the decorative line beneath the title
  final Color color;

  /// Reference to the scaffold key for drawer operations
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// Optional callback for when the profile icon is tapped
  /// If null, defaults to navigating to profile page (index 5)
  final VoidCallback? onProfileTap;

  /// Callback function to handle navigation between different pages/screens
  /// Takes an integer index to determine which page to navigate to
  final void Function(int) onNavigate;

  SocialMediaAppbar({
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
      // Increased height to fit custom content layout
      toolbarHeight: 120,
      backgroundColor: Colors.white,
      // No elevation by default
      elevation: 0,
      // Subtle shadow when scrolled
      shadowColor: Colors.black.withOpacity(0.1),
      scrolledUnderElevation: 2,

      // Back button on the left side
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 28),
        onPressed: () {
          // Navigate back to index 7 (presumably the previous screen)
          onNavigate(7);
        },
      ),

      // Custom centered content area
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            // Main title text
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

            // Decorative colored line beneath the title
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

      // Profile button on the right side
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, size: 40),
          tooltip: 'Profile',
          onPressed:
              // Use custom callback if provided, otherwise navigate to profile (index 5)
              onProfileTap ??
              () {
                onNavigate(5); // Navigate to profile page
              },
        ),
        // Right padding
        const SizedBox(width: 8),
      ],
    );
  }

  /// Required override for PreferredSizeWidget
  /// Defines the height of the app bar
  @override
  Size get preferredSize => const Size.fromHeight(120);
}
