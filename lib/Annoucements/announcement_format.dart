import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:intl/intl.dart';

class AnnouncementFormat extends StatelessWidget {
  AnnouncementFormat({
    required this.announcement,
    super.key,
  });

  final Map<String, dynamic> announcement;
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  void _onRemoveAnnouncement(BuildContext context, Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Delete Announcement",
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete '${announcement['title']}'? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  // Capture navigator and messenger synchronously to avoid using BuildContext after an await
                  final navigator = Navigator.of(ctx);
                  final messenger = ScaffoldMessenger.of(context);

                  await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(announcement['code'])
                        .collection('announcements')
                        .doc(announcement['id'])
                        .delete();

                  // Close the dialog using the captured navigator
                  navigator.pop();

                  // Show confirmation snackbar using the captured messenger
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Announcement deleted successfully'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
                  Expanded(
                    child: Text(
                      DateFormat.yMd().format((announcement['date'].toDate())),
                      style: TextStyle(
                        color: primaryBlue.withOpacity(0.7),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ),
                  if (_isAdvisor)
                    IconButton(
                        onPressed: () => _onRemoveAnnouncement(context, announcement),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[300],
                          size: 26,
                        ),
                        tooltip: 'Delete Announcement',
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
