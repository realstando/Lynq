import 'package:coding_prog/Annoucements/new_announcement.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement_format.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({
    super.key,
    required this.onNavigate,
  });
  final void Function(int) onNavigate;

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  void _openAddAnnouncementOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewAnnouncement(() {
          setState(() {});
          Navigator.pop(context);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAnnouncements =
        global.announcements != null && global.announcements!.isNotEmpty;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Announcements',
        color: const Color(0xFF0A2E7F),
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Announcements',
        color: const Color(0xFF1E3A8A),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButton: _isAdvisor
          ? FloatingActionButton.extended(
              onPressed: _openAddAnnouncementOverlay,
              backgroundColor: const Color(0xFF2563EB),
              icon: const Icon(Icons.edit_note, color: Colors.white),
              label: const Text(
                "New Announcement",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            )
          : null,
      body: hasAnnouncements
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              itemCount: global.announcements!.length,
              itemBuilder: (context, index) {
                final announcement = global.announcements![index];
                return AnnouncementFormat(announcement: announcement);
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
