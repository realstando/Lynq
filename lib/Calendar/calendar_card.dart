import 'package:flutter/material.dart';
import 'calendar.dart';

class CalendarCard extends StatelessWidget {
  const CalendarCard(this.calendar, {super.key});

  final Calendar calendar;

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFFFCECE),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Star decoration in top-right
          Positioned(
            top: -5,
            right: -5,
            child: Icon(
              Icons.star,
              color: Color(0xFFFFB84D),
              size: 45,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calendar.event,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                calendar.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              // Date and Location row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Text(
                    'Date: ${calendar.date.month}/${calendar.date.day}/${calendar.date.year}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),

                  // Location with icon
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        calendar.location,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
