import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:intl/intl.dart';

class AnnouncementFormat extends StatelessWidget {
  const AnnouncementFormat({
    required this.announcement,
    super.key,
  });

  final Map<String, dynamic> announcement;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(
      0xFF2563EB,
    ); // same tone as EventsFormat's objective blue
    const Color deepBlue = Color(0xFF1E3A8A);
    const Color gold = Color(0xFFFFD54F);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFE8EDFF), // subtle blue-tinted white
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: primaryBlue.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Avatar badge (similar glow effect)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          primaryBlue,
                          deepBlue,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Text(
                        "a",
                        style: const TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      announcement['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.star_rounded,
                    color: gold,
                    size: 28,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                announcement['title'],
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              // Decorative divider (gold gradient like EventsFormat accent)
              Container(
                height: 2,
                width: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFD54F),
                      Color(0xFFFFB300),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),

              const SizedBox(height: 10),

              // Content
              Text(
                announcement['content'],
                style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.grey[800],
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 20),

              // Footer (date row)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: primaryBlue.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMd().format((announcement['date'].toDate())),
                    style: TextStyle(
                      color: primaryBlue.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
