import 'package:coding_prog/Calendar/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events_page.dart';
import 'package:coding_prog/Annoucements/announcements_page.dart';
import 'package:coding_prog/Resources/resource_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ResourcePage(),
        backgroundColor: Colors.white,
      ),
    ),
  );
}
