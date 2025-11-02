import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: EventsPage(),
        backgroundColor: Colors.white,
      ),
    ),
  );
}
