import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement.dart';

class AnnouncementFormat extends StatelessWidget {
  const AnnouncementFormat({required this.announcement, super.key});
  final Announcement announcement;

  @override
  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF0A2E7F).withValues(alpha: 0.9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFD9D9D9),
                  child: Text(
                    announcement.initial,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    announcement.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 35,
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 3,
            color: Color(0xFF0A2E7F).withValues(alpha: 0.5),
          ),

          // Content Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1345B6),
                  Color(0xFF0A2E7F),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  announcement.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 15),

                // Decorative line
                Container(
                  height: 2,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // Content
                Text(
                  announcement.content,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),

                // Date with icon
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      announcement.formattedDate,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
