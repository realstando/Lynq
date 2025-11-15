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
    const Color primaryBlue = Color(0xFF1D52BC);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: primaryBlue,
                    child: Text(
                      announcement['name'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      announcement['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.campaign,
                    color: primaryBlue.withOpacity(0.6),
                    size: 22,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Title
              Text(
                announcement['title'],
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              // Content
              Text(
                announcement['content'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

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
                      fontSize: 13,
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
