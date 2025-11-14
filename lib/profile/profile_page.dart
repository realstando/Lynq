import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:coding_prog/profile/profile_formats.dart';
import 'package:coding_prog/profile/profile_lists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:intl/intl.dart';

enum MenuAction { logout }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.onNavigate});
  final void Function(int) onNavigate;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // FBLA Official Colors
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);
  static const fblaLightGold = Color(0xFFFFF4E0);

  @override
  Widget build(BuildContext context) {
    final String name = globals.currentUserName ?? 'Member';
    final String email = globals.currentUserEmail ?? 'Member';
    // final String school = 'Stanford University';
    final List<String> events = [
      'MAD',
      'Test',
    ];
    // final List<ProfileEvents> activities = [
    //   ProfileEvents(
    //     eventDate: DateTime(2025, 11, 8, 9),
    //     eventName: 'Team Stand-up',
    //   ),
    //   ProfileEvents(eventDate: DateTime(2025, 11, 22, 7), eventName: 'NCCC'),
    //   ProfileEvents(
    //     eventDate: DateTime(2026, 2, 4, 8, 30),
    //     eventName: 'Regionals',
    //   ),
    // ];

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Profile',
        color: const Color(0xFF0A2E7F),
        onNavigate: widget.onNavigate,
      ),
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
        actions: [
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
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
            // Header with gradient (similar to home page)
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

            // My Events Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionHeader('My Events'),
                  const SizedBox(height: 14),
                  ...events.map((event) => _buildEventCard(event)).toList(),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Scheduled Activities Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionHeader('Scheduled Events'),
                  const SizedBox(height: 14),
                  if (global.calendar!.isEmpty)
                    const Text(
                      'No scheduled events.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    )
                  else 
                  ...global.calendar!
                      .map(
                        (cal) => _buildActivityCard(
                          cal['name'],
                          DateFormat('E, MMM d \'@\' h:mm a').format(cal['date'].toDate()),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: fblaNavy,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

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
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [fblaNavy, Color(0xFF00528a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
  ).then((value) => value ?? false);
}
