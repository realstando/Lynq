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
  double _topHeight = 620.0;
  String _filterMode = 'all'; // 'all', 'upcoming', 'today', 'selected'

  final List<Calendar> calendars = [
    Calendar(
      "Washington SBLC",
      DateTime.utc(2025, 4, 26),
      "Bellevue Washington",
    ),
    Calendar(
      "Anaheim NLC",
      DateTime.utc(2025, 6, 26),
      "Anaheim California",
    ),
  ];

  @override
  Widget build(context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Top section - FIXED HEIGHT
          SizedBox(
            height: _topHeight,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF003B7E), Color(0xFF002856)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          "FBLA Calendar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: 80,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Color(0xFFE8B44C),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Calendar Container
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: TableCalendar(
                        rowHeight: 55,
                        firstDay: DateTime.utc(2024, 10, 16),
                        lastDay: DateTime.utc(2026, 10, 16),
                        focusedDay: focused,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003B7E),
                          ),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Color(0xFF003B7E),
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Color(0xFF003B7E),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8B44C).withOpacity(0.1),
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Color(0xFFE8B44C),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFF003B7E),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          weekendTextStyle: TextStyle(
                            color: Colors.red[400],
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Color(0xFF003B7E),
                            fontWeight: FontWeight.w600,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) => isSameDay(day, selected),
                        onDaySelected: (selectedDate, focusedDate) {
                          setState(() {
                            selected = selectedDate;
                            focused = focusedDate;
                          });
                        },
                      ),
                    ),
                  ),

                  // Filter Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildFilterButton(
                            "Upcoming",
                            Icons.upcoming,
                            'upcoming',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterButton(
                            "Today",
                            Icons.today,
                            'today',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterButton(
                            "Selected",
                            Icons.event_note,
                            'selected',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // DRAGGABLE DIVIDER
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
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8B44C), Color(0xFFD4A035)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.drag_handle_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 22,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "DRAG TO RESIZE",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom section - EXPANDED
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[50]!,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Events Header
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: Color(0xFF003B7E),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003B7E),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8B44C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${calendars.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Events List
                  Expanded(
                    child: calendars.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "No events scheduled",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: calendars.length,
                            itemBuilder: (context, index) =>
                                CalendarCard(calendars[index]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, IconData icon, String mode) {
    final isSelected = _filterMode == mode;
    return Container(
      height: 44,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _filterMode = mode;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF003B7E) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Color(0xFF003B7E),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Color(0xFF003B7E) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
