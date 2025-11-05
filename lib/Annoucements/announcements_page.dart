import 'package:coding_prog/Annoucements/new_announcement.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement_format.dart';
import 'package:coding_prog/Annoucements/announcement.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() {
    return _AnnouncementsPageState();
  }
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
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

  final List<Announcement> announcements = [
    Announcement(
      initial: "WA",
      name: "Washington FBLA",
      title: "Time Change for Network Design ",
      content:
          "Hey students! There will be a time change for the roleplay event Network Design as a result of the xyz. Thanks!",
      date: DateTime.now(),
    ),
    Announcement(
      initial: "Naur",
      name: "Georgia FBLA",
      title: "I HATE PUSHKAL ",
      content: "Hey students! Let us kill pushkal now!",
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20, right: 8),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: Color(0xFFE8B44C),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE8B44C).withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openAddAnnouncementOverlay,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_note, color: Color(0xFF003B7E), size: 26),
                    SizedBox(width: 10),
                    Text(
                      "New Post",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Text(
            "Announcements",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE8F0FF),
                    Color(0xFFD6E4FF),
                  ],
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: announcements.length,
                itemBuilder: (context, index) =>
                    AnnouncementFormat(announcement: announcements[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
