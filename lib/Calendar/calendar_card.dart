import 'package:flutter/material.dart';
import 'package:coding_prog/Calendar/calendar.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard(this.calendar, {super.key});

  final Map<String, dynamic> calendar;

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

  @override
  Widget build(context) {
    const fblaNavy = Color(0xFF0A2E7F);
    const fblaGold = Color(0xFFF4AB19);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fblaNavy.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fblaNavy.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Box
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
                  Text(
                    calendar['date'].toDate().day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatDate(
                      calendar['date'].toDate(),
                    ).split(' ')[0].toUpperCase(),
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

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event Title
                  Text(
                    calendar['event'],
                    style: TextStyle(
                      color: fblaNavy,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),

                  // Location
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
                          calendar['location'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron/Arrow
            Icon(
              Icons.chevron_right,
              color: fblaNavy.withOpacity(0.3),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}
