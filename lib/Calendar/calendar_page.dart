import 'package:coding_prog/Calendar/new_calendar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar.dart';
import 'calendar_card.dart';
import 'package:coding_prog/Calendar/new_calendar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.onNavigate,
    required this.calendars,
    required this.onAddCalendar,
  });
  final void Function(int) onNavigate;
  final List<Calendar> calendars;
  final void Function(Calendar) onAddCalendar;

  @override
  State<CalendarPage> createState() {
    return CalendarPageState();
  }
}

class CalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime focused = DateTime.now();
  DateTime? selected;
  double _topHeight = 620.0;
  String _filterMode = 'all'; // 'all', 'upcoming', 'today', 'selected'

  final List<Calendar> calendars = [
    Calendar(
      "Washington SBLC",
      DateTime.utc(2026, 4, 26),
      "Bellevue Washington",
    ),
    Calendar(
      "Anaheim NLC",
      DateTime.utc(2026, 6, 26),
      "Anaheim California",
    ),
  ];

  List<Calendar> get _filteredCalendars {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_filterMode) {
      case 'upcoming':
        final oneMonthFromNow = DateTime(now.year, now.month + 1, now.day);

        final futureEvents = calendars.where((calendar) {
          final eventDate = DateTime(
            calendar.date.year,
            calendar.date.month,
            calendar.date.day,
          );
          return eventDate.isAfter(today.subtract(Duration(days: 1)));
        }).toList();

        futureEvents.sort((a, b) => a.date.compareTo(b.date));

        if (futureEvents.length <= 5) {
          return futureEvents;
        }

        return futureEvents.where((calendar) {
          final eventDate = DateTime(
            calendar.date.year,
            calendar.date.month,
            calendar.date.day,
          );
          return eventDate.isBefore(oneMonthFromNow.add(Duration(days: 1)));
        }).toList();

      case 'today':
        return calendars.where((calendar) {
          final eventDate = DateTime(
            calendar.date.year,
            calendar.date.month,
            calendar.date.day,
          );
          return isSameDay(eventDate, today);
        }).toList();

      case 'selected':
        if (selected == null) {
          return [];
        }
        return calendars.where((calendar) {
          return isSameDay(calendar.date, selected);
        }).toList();

      default: // 'all'
        return calendars;
    }
  }

  void _openAddResourceOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewCalendar(addCalendar: _onAddCalendar),
      ),
    );
  }

  void _onAddCalendar(Calendar calendar) {
    setState(() {
      calendars.insert(0, calendar);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Calendar',
        color: const Color(0xFFF4AB19), // Deep blue
        onNavigate: widget.onNavigate,
      ),

      body: Column(
        children: [
          Container(
            height: _topHeight,
            child: SingleChildScrollView(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Menu Icon (left)
                              IconButton(
                                icon: const Icon(
                                  Icons.menu_rounded,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                              ),
                              SizedBox(width: 10),
                              // Title (centered)
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "FBLA Calendar",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),

                              // Spacer for symmetry (right side)
                              IconButton(
                                icon: const Icon(
                                  Icons.account_circle,
                                  size: 40,
                                ),
                                color: Colors.white,
                                tooltip: 'Profile',
                                onPressed: (() {
                                  widget.onNavigate(5);
                                }),
                              ), // same width as icon for visual balance
                            ],
                          ),
                        ),

                        SizedBox(height: 12),
                        Container(
                          width: 200,
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
                _topHeight = _topHeight.clamp(200.0, screenHeight - 270.0);
              });
            },
            child: Container(
              width: double.infinity,
              height: 38,
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
                            "${_filteredCalendars.length}",
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
                    child: _filteredCalendars.isEmpty
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
                            itemCount: _filteredCalendars.length,
                            itemBuilder: (context, index) =>
                                CalendarCard(_filteredCalendars[index]),
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
