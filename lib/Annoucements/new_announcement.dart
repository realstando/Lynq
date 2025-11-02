import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement.dart';

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({required this.addAnnouncement, super.key});
  final void Function(Announcement announcement) addAnnouncement;

  @override
  State<NewAnnouncement> createState() {
    return _NewAnnouncementState();
  }
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final _titleController = TextEditingController();
  final _informationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _informationController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    if ((_informationController.text).isEmpty ||
        (_informationController.text).isEmpty) {
      showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            title: Text("NO INFORMATION SUBMITTED DUMBASS BITCH"),
            content: Text("Please make sure to have valid inputs"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Okay!"),
              ),
            ],
          );
        }),
      );
      return;
    }
    Announcement announcement = Announcement(
      content: _informationController.text,
      title: _titleController.text,
      initial: "WA",
      name: "Washington SBLC",
      date: DateTime.now(),
    );
    widget.addAnnouncement(announcement);
  }

  @override
  Widget build(context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text(
          "New Announcement",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF5788EA),
      ),
      backgroundColor: Colors.white,

      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: TextField(
              controller: _titleController,
              maxLength: 75,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: "Type In Subject Here...",
                border: OutlineInputBorder(),
                counter: Offstage(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: TextField(
              controller: _informationController,
              maxLength: 75,
              maxLines: null,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: "Type In Announcement Here...",
                border: OutlineInputBorder(),
                counter: Offstage(),
                contentPadding: EdgeInsets.symmetric(vertical: 50),
              ),
            ),
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              _submitExpense();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF000293),
              padding: EdgeInsets.symmetric(horizontal: 100),
            ),
            child: Text("Post"),
          ),
        ],
      ),
    ));
  }
}
