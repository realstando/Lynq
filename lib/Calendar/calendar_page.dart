import 'package:coding_prog/Calendar/new_calendar.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar.dart';
import 'calendar_card.dart';
import 'package:coding_prog/Calendar/new_calendar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_actionbutton.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.onNavigate,
  });
  final void Function(int) onNavigate;

  @override
  State<CalendarPage> createState() {
    return CalendarPageState();
  }
}

class CalendarPageState extends State<CalendarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _isAdvisor = globals.currentUserRole == 'advisors';
  DateTime focused = DateTime.now();
  DateTime? selected;
  double _topHeight = 620.0;
  String _filterMode = 'all';

  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  List<Map<String, dynamic>> get _filteredCalendars {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_filterMode) {
      case 'upcoming':
        final futureEvents = global.calendar!.where((calendar) {
          final eventDate = calendar['date'].toDate();
          final eventDay = DateTime(
            eventDate.year,
            eventDate.month,
            eventDate.day,
          );
          return eventDay.isAfter(today.subtract(Duration(days: 1)));
        }).toList();

        futureEvents.sort(
          (a, b) => a['date'].toDate().compareTo(b['date'].toDate()),
        );

        if (futureEvents.length <= 5) {
          return futureEvents;
        }

        final oneMonthFromNow = DateTime(now.year, now.month + 1, now.day);
        return futureEvents.where((calendar) {
          final eventDate = calendar['date'].toDate();
          final eventDay = DateTime(
            eventDate.year,
            eventDate.month,
            eventDate.day,
          );
          return eventDay.isBefore(oneMonthFromNow.add(Duration(days: 1)));
        }).toList();

      case 'today':
        return global.calendar!.where((calendar) {
          final eventDate = calendar['date'].toDate();
          final eventDay = DateTime(
            eventDate.year,
            eventDate.month,
            eventDate.day,
          );
          return isSameDay(eventDay, today);
        }).toList();

      case 'selected':
        if (selected == null) {
          return [];
        }
        return global.calendar!.where((calendar) {
          return isSameDay(calendar['date'].toDate(), selected);
        }).toList();

      default:
        return global.calendar!;
    }
  }

  void _openAddResourceOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewCalendar(() {
          setState(() {});
          Navigator.pop(context);
        }),
      ),
    );
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
        color: fblaGold,
        onNavigate: widget.onNavigate,
      ),
      floatingActionButton: _isAdvisor
          ? CustomActionButton(
              openAddPage: _openAddResourceOverlay,
              name: "New Event",
              icon: Icons.calendar_month_outlined,
            )
          : null,
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
                    color: fblaNavy,
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: 200,
                          height: 3,
                          decoration: BoxDecoration(
                            color: fblaGold,
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
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
                            color: fblaNavy,
                          ),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: fblaNavy,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: fblaNavy,
                          ),
                          decoration: BoxDecoration(
                            color: fblaGold.withOpacity(0.1),
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: fblaGold,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: fblaNavy,
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
                            color: fblaNavy,
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
                            "All",
                            Icons.calendar_month,
                            'all',
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
              color: fblaGold,
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
              color: Colors.grey[50],
              child: Column(
                children: [
                  // Events Header
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: fblaNavy,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: fblaNavy,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: fblaGold,
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
          backgroundColor: isSelected ? fblaNavy : Colors.white,
          foregroundColor: isSelected ? Colors.white : fblaNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? fblaNavy : Colors.grey[300]!,
              width: 1.5,
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
