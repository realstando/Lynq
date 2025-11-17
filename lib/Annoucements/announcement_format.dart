import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A card widget that displays an announcement with formatted content
/// Shows group name, title, content, and timestamp
/// Advisors see a delete button to remove announcements
/// Features FBLA blue theming with subtle background and border
class AnnouncementFormat extends StatelessWidget {
  AnnouncementFormat({
    required this.announcement,
    super.key,
  });

  /// The announcement data to display
  /// Expected fields: 'name' (group), 'title', 'content', 'date', 'code', 'id'
  final Map<String, dynamic> announcement;

  /// Check if current user has advisor privileges
  /// Only advisors can delete announcements
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  /// Shows a confirmation dialog before deleting an announcement
  /// Prevents accidental deletions with a clear warning message
  /// Deletes from Firestore path: groups/{code}/announcements/{id}
  /// Shows success feedback via SnackBar after deletion
  ///
  /// [context] - Build context for showing dialogs and snackbars
  /// [announcement] - The announcement to delete (needs 'code' and 'id' fields)
  void _onRemoveAnnouncement(
    BuildContext context,
    Map<String, dynamic> announcement,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Dialog title with delete icon
          title: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red, // Red for destructive action
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Delete Announcement",
                  style: TextStyle(
                    color: Color(0xFF003B7E), // FBLA Navy
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Warning message showing which announcement will be deleted
          content: Text(
            "Are you sure you want to delete '${announcement['title']}'? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // Cancel button - dismisses dialog without deleting
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
            // Delete button - red background for destructive action
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  // IMPORTANT: Capture navigator and messenger BEFORE async operation
                  // Using BuildContext after await can cause errors if widget is unmounted
                  final navigator = Navigator.of(ctx);
                  final messenger = ScaffoldMessenger.of(context);

                  // Delete announcement from Firestore
                  // Path: groups/{groupCode}/announcements/{announcementId}
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(announcement['code']) // Group identifier
                      .collection('announcements')
                      .doc(announcement['id']) // Announcement identifier
                      .delete();

                  // Close the confirmation dialog using captured navigator
                  navigator.pop();

                  // Show success feedback using captured messenger
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Announcement deleted successfully'),
                      backgroundColor: Colors.red, // Red to match delete action
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
    // FBLA blue for consistent theming
    const Color primaryBlue = Color(0xFF1D52BC);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Light blue background with subtle border
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08), // Very light blue tint
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3), // Semi-transparent blue border
          width: 1.5,
        ),
      ),
      // Material wrapper for elevation and rounded corners
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER ROW =====
              // Group avatar, name, and announcement icon
              Row(
                children: [
                  // Circle avatar with first letter of group name
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: primaryBlue,
                    child: Text(
                      announcement['name'][0].toUpperCase(), // First letter
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Group/chapter name
                  Expanded(
                    child: Text(
                      announcement['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF0F172A), // Dark text
                      ),
                      overflow: TextOverflow.ellipsis, // Truncate if too long
                    ),
                  ),
                  // Announcement/megaphone icon
                  Icon(
                    Icons.campaign,
                    color: primaryBlue.withOpacity(0.6),
                    size: 22,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ===== TITLE =====
              // Main announcement subject/heading
              Text(
                announcement['title'],
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3, // Line height for readability
                ),
              ),

              const SizedBox(height: 8),

              // ===== CONTENT =====
              // Full announcement message body
              Text(
                announcement['content'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4, // Comfortable line spacing
                ),
              ),

              const SizedBox(height: 16),

              // ===== FOOTER ROW =====
              // Date posted and optional delete button (advisors only)
              Row(
                children: [
                  // Calendar icon
                  Icon(
                    Icons.calendar_today,
                    color: primaryBlue.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  // Formatted date (e.g., "12/25/2024")
                  Expanded(
                    child: Text(
                      DateFormat.yMd().format((announcement['date'].toDate())),
                      style: TextStyle(
                        color: primaryBlue.withOpacity(0.7),
                        fontSize: 13,
                        fontStyle:
                            FontStyle.italic, // Subtle styling for metadata
                      ),
                    ),
                  ),
                  // Delete button - only visible to advisors
                  if (_isAdvisor)
                    IconButton(
                      onPressed: () =>
                          _onRemoveAnnouncement(context, announcement),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[300], // Light red for delete action
                        size: 26,
                      ),
                      tooltip: 'Delete Announcement', // Accessibility label
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
