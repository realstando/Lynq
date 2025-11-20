import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/Calendar/calendar.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';

/// Stateless widget that displays a calendar event card
/// Shows event date, title, location, and delete button (for advisors only)
class CalendarCard extends StatelessWidget {
  CalendarCard(this.calendar, {super.key});

  /// Map containing event data (event, location, date, code, id)
  final Calendar calendar;

  /// Flag to check if current user is an advisor (only advisors can delete events)
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  /// Formats a DateTime object into a readable string format
  /// Returns format: "MMM DD, YYYY" (e.g., "Jan 15, 2025")
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Shows a confirmation dialog before deleting an event
  /// Only accessible by advisors
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing dialog
  /// - [cal]: Map containing the event data to be deleted
  void _onRemoveCal(BuildContext context, Calendar cal) {
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
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Delete Event",
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Confirmation message showing event title
          content: Text(
            "Are you sure you want to delete '${cal.event}'? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // Cancel button
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
            // Delete button (red background)
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  // Capture navigator and messenger synchronously to avoid using
                  // BuildContext after an async operation (await)
                  final navigator = Navigator.of(ctx);
                  final messenger = ScaffoldMessenger.of(context);

                  // Delete the event from Firestore
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(cal.code)
                      .collection('calendar')
                      .doc(cal.event)
                      .delete();

                  // Close the dialog using the captured navigator
                  navigator.pop();

                  // Show success snackbar using the captured messenger
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Event deleted successfully'),
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
  Widget build(context) {
    // FBLA brand colors
    const fblaNavy = Color(0xFF0A2E7F);
    const fblaGold = Color(0xFFF4AB19);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fblaNavy.withOpacity(0.08), // Light navy background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fblaNavy.withOpacity(0.3), // Semi-transparent navy border
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Box - Shows day number and month abbreviation
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: fblaNavy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Day number (e.g., "15")
                  Text(
                    calendar.date.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Month abbreviation (e.g., "JAN")
                  Text(
                    _formatDate(
                          calendar.date,
                        )
                        .split(' ')[0]
                        .toUpperCase(), // Extract month from formatted date
                    style: TextStyle(
                      color: fblaGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 16),

            // Event Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event Title
                  Text(
                    calendar.event,
                    style: TextStyle(
                      color: fblaNavy,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2, // Allow up to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Add "..." if text is too long
                  ),

                  SizedBox(height: 8),

                  // Location with icon
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: fblaGold,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          calendar.location,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis, // Truncate if too long
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete Button - Only shown if user is an advisor
            if (_isAdvisor)
              IconButton(
                onPressed: () => _onRemoveCal(context, calendar),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[300],
                  size: 26,
                ),
                tooltip: 'Delete Event',
              ),
          ],
        ),
      ),
    );
  }
}
