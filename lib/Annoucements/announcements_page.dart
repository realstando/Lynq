import 'package:coding_prog/Annoucements/new_announcement.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement_format.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_actionbutton.dart';

/// StatefulWidget for displaying all announcements
/// Shows a scrollable list of announcements or an empty state when none exist
/// Advisors can create new announcements via a floating action button
class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({
    super.key,
    required this.onNavigate,
  });

  /// Callback function to handle navigation to different pages
  final void Function(int) onNavigate;

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  // Global key to control the Scaffold state (used for opening drawer)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Flag to check if current user is an advisor
  /// Only advisors can create new announcements
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  /// Opens the new announcement form as a modal screen
  /// After creating an announcement, refreshes the page and closes the form
  void _openAddAnnouncementOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewAnnouncement(() {
          setState(() {}); // Refresh the announcements list
          Navigator.pop(context); // Close the form
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    // Check if there are any announcements to display
    final hasAnnouncements =
        global.announcements.isNotEmpty;

    return Scaffold(
      key: _scaffoldKey,
      // Navigation drawer
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Announcements',
        color: const Color(0xFF0A2E7F),
        onNavigate: widget.onNavigate,
      ),
      // Custom app bar
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Announcements',
        color: const Color(0xFF1E3A8A),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: const Color(0xFFF7F9FC), // Light blue-grey background
      // Floating action button - only shown for advisors
      floatingActionButton: _isAdvisor
          ? CustomActionButton(
              openAddPage: _openAddAnnouncementOverlay,
              name: "New Announcement",
              icon: Icons.campaign_rounded,
            )
          : null,
      body: hasAnnouncements
          // List of announcements when data exists
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              itemCount: global.announcements.length,
              itemBuilder: (context, index) {
                final announcement = global.announcements[index];
                // Display each announcement using AnnouncementFormat widget
                return AnnouncementFormat(announcement: announcement);
              },
            )
          // Empty state when no announcements exist
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with light background
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A2E7F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Image(
                        image: AssetImage('assets/Lynq_Logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Empty state message
                  const Text(
                    'No announcements yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }
}
