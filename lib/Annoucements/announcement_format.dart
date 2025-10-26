import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement.dart';

class AnnouncementFormat extends StatelessWidget {
  AnnouncementFormat({required this.announcement, super.key});
  final Announcement announcement;

  Widget build(context) {
    return Column(
      children: [
        Container(
          color: Color(0xFF0A2E7F).withValues(alpha: 0.8),
          height: 90,
          child: Row(
            children: [
              SizedBox(width: 10),
              CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFFD9D9D9),
                child: Text(
                  announcement.initial,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Spacer(),
              Text(
                announcement.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Spacer(),
              Icon(
                Icons.star, // A solid star
                color: Colors.amber,
                size: 60.0,
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          height: 5,
          thickness: 5,
        ),
        Container(
          color: Color(0xFF1345B6),
          //height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.directional(end: 20, start: 25),
                child: Text(
                  announcement.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsetsGeometry.directional(end: 20, start: 25),
                child: Text(
                  announcement.content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: EdgeInsetsGeometry.directional(end: 20, start: 25),
                child: Text(
                  announcement.formattedDate,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
