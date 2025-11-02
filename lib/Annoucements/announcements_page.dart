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
          "Hey students! There will be a time change for the roleplay event “Network Design” as a result of the xyz. Thanks!",
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAnnouncementOverlay,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "Announcements",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Color(0xFFE3F2FD),
              child: ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) =>
                    AnnouncementFormat(announcement: announcements[index]),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
