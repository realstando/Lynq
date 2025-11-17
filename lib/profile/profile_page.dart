import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Enum for popup menu actions in the AppBar
enum MenuAction { logout }

/// A StatefulWidget that displays the user's profile page
/// Shows user information, enrolled events, and scheduled activities
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.onNavigate});

  /// Callback function to navigate to different pages by index
  final void Function(int) onNavigate;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// Key for accessing the Scaffold state (e.g., for drawer)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // FBLA Official Brand Colors
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);
  static const fblaLightGold = Color(0xFFFFF4E0);

  @override
  Widget build(BuildContext context) {
    // Get current user information from global state
    final String name = globals.currentUserName ?? 'Member';
    final String email = globals.currentUserEmail ?? 'Member';

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // AppBar with logout menu
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: fblaNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        // Back button navigates to home page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onNavigate(0); // Navigate to home page (index 0)
          },
        ),
        // Three-dot menu with logout option
        actions: [
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  // Show confirmation dialog before logging out
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // Sign out from Firebase
                    await FirebaseAuth.instance.signOut();
                    // Navigate to login page and clear navigation stack
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                        (route) => false,
                      );
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background and user info
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [fblaNavy, Color(0xFF00528a)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: fblaNavy.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
              child: Center(
                child: Column(
                  children: [
                    // Profile avatar with gold gradient border
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            fblaGold.withValues(alpha: 0.6),
                            Color(0xFFFFD666).withValues(alpha: 0.6),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: fblaGold.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 56,
                          color: fblaNavy.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // User email with school icon
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school,
                            size: 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // My Events Section - displays events user is enrolled in
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionHeader('My Events'),
                  const SizedBox(height: 14),
                  // Show empty state if no events, otherwise display event cards
                  if (global.events!.isEmpty)
                    _buildEmptyState(
                      'No events yet',
                      'Join events to see them here',
                      Icons.event_busy,
                    )
                  else
                    ...global.events!.map((event) => _buildEventCard(event)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Scheduled Activities Section - displays upcoming calendar events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionHeader('Scheduled Events'),
                  const SizedBox(height: 14),
                  // Show empty state if no scheduled events
                  if (global.calendar == null || global.calendar!.isEmpty)
                    _buildEmptyState(
                      'No scheduled events',
                      'Check back later for upcoming activities',
                      Icons.calendar_today,
                    )
                  else
                    // Display each scheduled event with formatted date/time
                    ...global.calendar!
                        .map(
                          (cal) => _buildActivityCard(
                            cal['name'],
                            // Format: "Mon, Jan 1 @ 3:00 PM"
                            DateFormat(
                              'E, MMM d \'@\' h:mm a',
                            ).format(cal['date'].toDate()),
                          ),
                        )
                        .toList(),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Builds a section header with logo and title
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        // Logo container
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: fblaNavy.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Image(
              image: AssetImage('assets/Lynq_Logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Section title
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: fblaNavy,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  /// Builds an empty state widget when no data is available
  /// Used for both events and scheduled activities
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Logo container
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: fblaNavy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Image(
                image: AssetImage('assets/Lynq_Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Empty state title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          // Empty state subtitle/description
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a card displaying an event that the user is enrolled in
  Widget _buildEventCard(String eventName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Event icon with gold gradient background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [fblaLightGold, Color(0xFFFFF9EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE7B3)),
            ),
            child: const Icon(
              Icons.event,
              color: fblaNavy,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          // Event name
          Expanded(
            child: Text(
              eventName,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: fblaNavy,
                letterSpacing: -0.3,
              ),
            ),
          ),
          // Forward arrow indicator
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  /// Builds a card displaying a scheduled activity with date and time
  Widget _buildActivityCard(String activity, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar icon with navy background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: fblaNavy,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: fblaNavy.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Activity details (name and time)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity name
                Text(
                  activity,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: fblaNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                // Activity time with clock icon
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a confirmation dialog asking the user if they want to sign out
/// Returns true if user confirms, false if cancelled
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF0A2E7F),
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          // Cancel button - returns false
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Sign Out button - returns true
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF0A2E7F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    },
    // Return false if dialog is dismissed without selection
  ).then((value) => value ?? false);
}
