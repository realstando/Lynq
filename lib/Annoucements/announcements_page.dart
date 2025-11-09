import 'package:coding_prog/Annoucements/new_announcement.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement_format.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({
    super.key,
    required this.onNavigate,
    required this.announcements,
    required this.onAddAnnouncement,
  });
  final void Function(int) onNavigate;
  final List<Announcement> announcements;
  final void Function(Announcement) onAddAnnouncement;

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Announcement> announcements = [
    Announcement(
      initial: "WA",
      name: "Washington FBLA",
      title: "Time Change for Network Design",
      content:
          "Hey students! There will be a time change for the roleplay event Network Design due to scheduling conflicts. Thanks for understanding!",
      date: DateTime.now(),
    ),
    Announcement(
      initial: "GA",
      name: "Georgia FBLA",
      title: "Regional Meeting Reminder",
      content:
          "Don’t forget: our regional leadership meeting is tomorrow at 10 AM. Check your emails for the Zoom link.",
      date: DateTime.now(),
    ),
  ];

  void _openAddAnnouncementOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            NewAnnouncement(addAnnouncement: _onAddAnnouncement),
      ),
    );
  }

  void _onAddAnnouncement(Announcement announcement) {
    setState(() {
      announcements.insert(0, announcement);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Announcements',
        color: const Color(0xFF1E3A8A), // Deep blue
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Announcements',
        color: const Color(0xFF1E3A8A),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddAnnouncementOverlay,
        backgroundColor: const Color(0xFF2563EB), // Clean medium blue
        icon: const Icon(Icons.edit_note, color: Colors.white),
        label: const Text(
          "New Announcement",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        elevation: 6,
      ),
      body: Column(
        children: [
          // Header banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E40AF).withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Latest Announcements",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    announcements.length.toString(),
                    style: const TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of announcements
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: announcements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Card(
                  elevation: 1.5,
                  shadowColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AnnouncementFormat(announcement: announcement),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
