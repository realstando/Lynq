import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
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
  String? selectedValue;

  List<String> get groupItems {
    if (globals.groups == null || globals.groups!.isEmpty) {
      return [];
    }
    return globals.groups!.map((group) {
      final name = group['name']?.toString() ?? '';
      final code = group['code']?.toString() ?? '';
      return '$name ($code)';
    }).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _informationController.dispose();
    super.dispose();
  }

  void _submitExpense() async {
    if (_titleController.text.trim().isEmpty ||
        _informationController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFFD700),
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  "Missing Information",
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              "Please fill in both the title and announcement content before posting.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF003B7E),
                ),
                child: Text(
                  "Got it!",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        }),
      );
      return;
    }

    try {
      print(selectedValue!.substring(selectedValue!.indexOf("(")+1, selectedValue!.indexOf(")")));
      await FirebaseFirestore.instance
          .collection('groups').doc(selectedValue!.substring(selectedValue!.indexOf("(")+1, selectedValue!.indexOf(")")))
          .collection('announcements')
          .add({
            'content': _informationController.text.trim(),
            'title': _titleController.text.trim(),
            'date': DateTime.now(),
      });
    } catch (_) {
    }

    Announcement announcement = Announcement(
      content: _informationController.text.trim(),
      title: _titleController.text.trim(),
      initial: "WA",
      name: "Washington SBLC",
      date: DateTime.now(),
    );
    widget.addAnnouncement(announcement);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Announcement",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF003B7E),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "Group",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedValue,
                hint: Text('Select a group', style: TextStyle(color: Colors.grey[400])),
                items: groupItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select a group',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Subject",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _titleController,
                maxLength: 75,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Enter announcement title...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  counter: Offstage(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Content",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _informationController,
                maxLength: 500,
                maxLines: 8,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Write your announcement here...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  counter: Offstage(),
                  contentPadding: EdgeInsets.all(16),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF003B7E), Color(0xFF002856)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF003B7E).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _submitExpense,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                              color: Color(0xFFFFD700),
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Post Announcement",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
