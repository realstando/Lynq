import 'package:flutter/material.dart';
import 'calendar.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard(this.calendar, {super.key});

  final Calendar calendar;

  @override
  Widget build(context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: Card(
        color: Color(0xFFFFCECE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40), // round corners
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                calendar.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('${calendar.event} • ${calendar.location}'),
              const SizedBox(height: 8),
              Text(
                '${calendar.date.year}-${calendar.date.month.toString().padLeft(2, '0')}-${calendar.date.day.toString().padLeft(2, '0')}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
