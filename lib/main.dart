import 'package:coding_prog/Annoucements/announcements_page.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/login_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AnnouncementsPage(),
        backgroundColor: Colors.white,
      ),
    ),
  );
}
