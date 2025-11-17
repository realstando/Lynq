// ==========================================
// social_media_hub.dart
// Selection screen for YouTube or Instagram
// Hub page that allows users to navigate to different social media platforms
// ==========================================

import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

/// Main hub widget for social media platform selection
/// Displays cards for YouTube and Instagram platforms
class SocialMediaHub extends StatefulWidget {
  const SocialMediaHub({super.key, required this.onNavigate});

  /// Callback function to navigate to different pages by index
  final void Function(int) onNavigate;

  @override
  State<SocialMediaHub> createState() => _SocialMediaHubState();
}

class _SocialMediaHubState extends State<SocialMediaHub> {
  /// Global key for managing the scaffold and drawer state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // FBLA Official Brand Colors
  static const fblaNavy = Color(0xFF0A2E7F); // Primary dark blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Custom drawer with social media icon and styling
      drawer: DrawerPage(
        icon: Icons.share_rounded,
        name: 'Social Media',
        color: Color(0xFFDD2A7B), // Pink/magenta accent color
        onNavigate: widget.onNavigate,
      ),
      // Custom app bar with consistent branding
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Social Media',
        color: Color(0xFFDD2A7B),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== Header Section ==========
              // Gradient header with page title and description
              Container(
                decoration: BoxDecoration(
                  // Navy blue gradient background
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [fblaNavy, Color(0xFF00528a)],
                  ),
                  // Subtle shadow for depth
                  boxShadow: [
                    BoxShadow(
                      color: fblaNavy.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon container with semi-transparent background
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 12),
                        // Header text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subtitle text
                              Text(
                                'Stay Connected',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Main title text
                              Text(
                                'FBLA Social Media',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Description text
                    Text(
                      'Connect with FBLA on your favorite platforms',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // ========== Platform Selection Cards Section ==========
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Text(
                      'Choose a Platform',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: fblaNavy,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 20),

                    // ========== YouTube Card ==========
                    _buildPlatformCard(
                      title: 'YouTube',
                      subtitle:
                          'Watch FBLA videos, competitions, and tutorials',
                      icon: Icons.play_circle_filled,
                      backgroundColor: Color(0xFFFF0000), // YouTube red
                      stats: [
                        {'icon': Icons.video_library, 'text': '500+ Videos'},
                        {'icon': Icons.people, 'text': '50K+ Subscribers'},
                      ],
                      onTap: () {
                        // Navigate to YouTube screen (index 9)
                        widget.onNavigate(9);
                      },
                    ),

                    SizedBox(height: 16),

                    // ========== Instagram Card ==========
                    _buildPlatformCard(
                      title: 'Instagram',
                      subtitle: 'Follow FBLA photos, stories, and updates',
                      icon: Icons.camera_alt,
                      backgroundColor: Color(0xFFE1306C), // Instagram pink
                      stats: [
                        {'icon': Icons.photo_library, 'text': '1000+ Posts'},
                        {'icon': Icons.favorite, 'text': '75K+ Followers'},
                      ],
                      onTap: () {
                        // Navigate to Instagram screen (index 8)
                        widget.onNavigate(8);
                      },
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a reusable platform card widget
  ///
  /// Parameters:
  /// - [title]: Platform name (e.g., "YouTube", "Instagram")
  /// - [subtitle]: Brief description of the platform content
  /// - [icon]: Icon to display in the platform badge
  /// - [backgroundColor]: Brand color for the platform icon
  /// - [stats]: List of statistics to display (icon and text pairs)
  /// - [onTap]: Callback when the card is tapped
  Widget _buildPlatformCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required List<Map<String, dynamic>> stats,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        // Subtle shadow for card elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        // InkWell provides tap animation and ripple effect
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ========== Platform Icon Badge ==========
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: backgroundColor, // Platform-specific color
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 16),
                    // ========== Platform Info ==========
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Platform name
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: fblaNavy,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Platform description
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow indicator for navigation
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Divider line
                Divider(color: Colors.grey.shade200),
                SizedBox(height: 12),
                // ========== Platform Statistics ==========
                // Display stats like follower count, video count, etc.
                Row(
                  children: stats.map((stat) {
                    return Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Stat icon
                          Icon(
                            stat['icon'] as IconData,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 6),
                          // Stat text
                          Flexible(
                            child: Text(
                              stat['text'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
