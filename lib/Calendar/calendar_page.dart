import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar.dart';
import 'calendar_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime focused = DateTime.now();
  DateTime? selected;
  double _topHeight = 650.0;

  final List<Calendar> calendars = [
    Calendar(
      "Conference",
      "Washington SBLC",
      DateTime.utc(2025, 4, 26),
      "Bellevue Washington",
    ),
    Calendar(
      "Conference",
      "Anaheim NLC",
      DateTime.utc(2025, 6, 26),
      "Anaheim California",
    ),
  ];

  @override
  Widget build(context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Top section - FIXED HEIGHT
          Container(
            height: _topHeight,
            child: SingleChildScrollView(
              // Allow scrolling if content too big
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 20),
                    child: Text(
                      "FBLA Calendar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xFFF4AB19),
                    height: 5,
                    thickness: 5,
                  ),
                  Container(
                    color: Color(0xFF3033BC),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: TableCalendar(
                          rowHeight: 55,
                          firstDay: DateTime.utc(2024, 10, 16),
                          lastDay: DateTime.utc(2026, 10, 16),
                          focusedDay: focused,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          availableGestures: AvailableGestures.all,
                          selectedDayPredicate: (day) =>
                              isSameDay(day, selected),
                          onDaySelected: (selectedDate, focusedDate) {
                            setState(() {
                              selected = selectedDate;
                              focused = focusedDate;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: (() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF6F6F6),
                          foregroundColor: Colors.black,
                        ),
                        child: (Text("Upcoming")),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: (() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF6F6F6),
                          foregroundColor: Colors.black,
                        ),
                        child: (Text("Today")),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: (() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF6F6F6),
                          foregroundColor: Colors.black,
                        ),
                        child: (Text("Selected")),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // DRAGGABLE DIVIDER - Theme matching version
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: (details) {
              setState(() {
                _topHeight += details.delta.dy;
                _topHeight = _topHeight.clamp(200.0, screenHeight - 150.0);
              });
            },
            child: Container(
              width: double.infinity,
              height: 15,
              color: Color(0xFFF4AB19), // Matches your yellow divider
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.drag_handle, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),

          // Bottom section - EXPANDED
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: calendars.length,
                itemBuilder: (context, index) => CalendarCard(calendars[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
