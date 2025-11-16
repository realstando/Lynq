import 'package:flutter/material.dart';

/// A custom app bar widget with gradient background, centered title, and profile button
/// Implements PreferredSizeWidget to work as a Scaffold appBar
/// Features a menu button (left), styled title with underline (center), and profile button (right)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the center of the app bar
  final String name;

  /// The base color for the app bar gradient
  /// This color will be used as the starting point for the gradient
  final Color color;

  /// The scaffold key used to control the drawer
  /// Passed from parent to enable opening the navigation drawer
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// Optional callback for when the profile button is tapped
  /// If null, defaults to navigating to index 5
  final VoidCallback? onProfileTap;

  /// Callback function to navigate to different pages by index
  /// Used when profile button is tapped (if onProfileTap is null)
  final void Function(int) onNavigate;

  CustomAppBar({
    super.key,
    required this.name,
    required this.color,
    required this.scaffoldKey,
    required this.onNavigate,
    this.onProfileTap,
  });

  /// Darkens a color by reducing its lightness value
  /// Used to create the gradient's darker end color
  ///
  /// [color] - The color to darken
  /// [amount] - How much to darken (0.0 to 1.0), defaults to 0.2
  /// Returns the darkened color
  Color _darkenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);

    // Convert to HSL (Hue, Saturation, Lightness) for easier manipulation
    final hsl = HSLColor.fromColor(color);

    // Reduce lightness and clamp to valid range
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );

    // Convert back to Color object
    return darkened.toColor();
  }

  /// Creates an accent color by increasing saturation
  /// Currently unused in the build method but available for future use
  ///
  /// [color] - The base color to accent
  /// Returns a more saturated version of the color
  Color _accentColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    // Increase saturation by 10% and clamp to valid range
    final accent = hsl.withSaturation((hsl.saturation + 0.1).clamp(0.0, 1.0));
    return accent.toColor();
  }

  @override
  Widget build(BuildContext context) {
    // Create a darker version of the base color for gradient effect
    final Color darkColor = _darkenColor(color, 0.15);
    // Create accent color (currently unused but available)
    final Color accentColor = _accentColor(color);

    return AppBar(
      // Increased height for more prominent header
      toolbarHeight: 80,
      backgroundColor:
          color, // Base color (overridden by flexibleSpace gradient)
      elevation: 0, // No shadow by default
      shadowColor: Colors.black.withOpacity(0.3),
      // Add shadow when user scrolls (Material 3 behavior)
      scrolledUnderElevation: 4,

      // Gradient background for visual appeal
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, darkColor], // Light to dark gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      // Left side - Menu button to open drawer
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, size: 28, color: Colors.white),
        onPressed: () {
          // Open the navigation drawer using the scaffold key
          scaffoldKey.currentState?.openDrawer();
        },
      ),

      // Center - Title with decorative underline
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title text
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                letterSpacing: -0.5, // Tight letter spacing for modern look
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Decorative underline bar beneath title
            Container(
              width: 60,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(2),
                // Add glow effect to the underline
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true, // Center the title horizontally
      // Right side - Profile button
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            // Circular button with semi-transparent background
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // Semi-transparent white background
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20), // Perfect circle
                // White border for definition
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              // Person icon centered in the circle
              child: const Icon(
                Icons.person_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
            tooltip: 'Profile', // Accessibility label
            // Handle tap - use custom callback or default to navigation
            onPressed:
                onProfileTap ?? // Use custom callback if provided
                () {
                  onNavigate(5); // Otherwise navigate to index 5 (profile page)
                },
          ),
        ),
      ],
    );
  }

  /// Required by PreferredSizeWidget interface
  /// Tells Flutter how much vertical space this app bar needs
  @override
  Size get preferredSize => const Size.fromHeight(80);
}
