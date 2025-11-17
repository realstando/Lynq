import 'package:coding_prog/Calendar/new_calendar.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_card.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_actionbutton.dart';

/// Calendar page featuring a resizable split view layout
/// Top section: Interactive calendar widget with date selection and filter controls
/// Bottom section: List of events based on current filter
/// Features a draggable divider allowing users to adjust the size ratio between sections
/// Only advisors can add new events via the floating action button
class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.onNavigate,
  });

  /// Callback function to navigate to other pages by index
  final void Function(int) onNavigate;

  @override
  State<CalendarPage> createState() {
    return CalendarPageState();
  }
}

class CalendarPageState extends State<CalendarPage> {
  /// Scaffold key for controlling the navigation drawer programmatically
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Check if current user is an advisor (advisors can add events)
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  /// The currently focused month/year in the calendar
  DateTime focused = DateTime.now();

  /// The date selected by the user (null if none selected)
  DateTime? selected;

  /// Height of the top section containing the calendar
  /// User can drag the divider to adjust this value
  double _topHeight = 620.0;

  /// Current filter mode: 'all', 'upcoming', 'today', or 'selected'
  /// Determines which events are shown in the bottom list
  String _filterMode = 'all';

  // FBLA Official Brand Colors
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  /// Filters the calendar events based on the current filter mode
  /// Returns a list of events that match the selected criteria
  /// Events are sorted chronologically for 'upcoming' mode
  List<Map<String, dynamic>> get _filteredCalendars {
    final now = DateTime.now();
    // Normalize today to midnight for accurate day comparisons
    final today = DateTime(now.year, now.month, now.day);

    switch (_filterMode) {
      case 'upcoming':
        // Get all future events (including today)
        final futureEvents = global.calendar!.where((calendar) {
          final eventDate = calendar['date'].toDate();
          final eventDay = DateTime(
            eventDate.year,
            eventDate.month,
            eventDate.day,
          );
          // Include events from today onwards
          return eventDay.isAfter(today.subtract(Duration(days: 1)));
        }).toList();

        // Sort events chronologically (earliest first)
        futureEvents.sort(
          (a, b) => a['date'].toDate().compareTo(b['date'].toDate()),
        );

        // If 5 or fewer events exist, show them all
        if (futureEvents.length <= 5) {
          return futureEvents;
        }

        // Otherwise, limit to events within the next month
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
        // Show only events happening today
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
        // Show events for the user-selected date
        // Return empty list if no date is selected
        if (selected == null) {
          return [];
        }
        return global.calendar!.where((calendar) {
          return isSameDay(calendar['date'].toDate(), selected);
        }).toList();

      default: // 'all' mode
        // Show all events without filtering
        return global.calendar!;
    }
  }

  /// Opens the overlay/dialog for adding a new calendar event
  /// Only available to advisors
  /// Refreshes the page after the event is added
  void _openAddResourceOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewCalendar(() {
          setState(() {}); // Refresh to show new event
          Navigator.pop(context); // Close the add event dialog
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
      // Navigation drawer with calendar branding
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Calendar',
        color: fblaGold,
        onNavigate: widget.onNavigate,
      ),
      // Floating action button - only shown for advisors
      floatingActionButton: _isAdvisor
          ? CustomActionButton(
              openAddPage: _openAddResourceOverlay,
              name: "New Event",
              icon: Icons.calendar_month_outlined,
            )
          : null,
      // Split layout: fixed top (calendar) + draggable divider + expandable bottom (events)
      body: Column(
        children: [
          // ===== TOP SECTION - CALENDAR =====
          // Fixed height container (user-adjustable via drag)
          SizedBox(
            height: _topHeight,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(), // Prevent overscroll bounce
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with title and navigation
                  Container(
                    width: double.infinity,
                    color: fblaNavy,
                    child: Column(
                      children: [
                        SizedBox(height: 40), // Top padding for status bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Menu button to open drawer
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
                              // Centered title
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
                              // Profile button
                              IconButton(
                                icon: const Icon(
                                  Icons.account_circle,
                                  size: 40,
                                ),
                                color: Colors.white,
                                tooltip: 'Profile',
                                onPressed: (() {
                                  widget.onNavigate(
                                    5,
                                  ); // Navigate to profile page
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        // Decorative gold underline
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

                  // Calendar Widget Container with custom styling
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
                        rowHeight: 55, // Height of each week row
                        firstDay: DateTime.utc(
                          2024,
                          10,
                          16,
                        ), // Calendar start date
                        lastDay: DateTime.utc(
                          2026,
                          10,
                          16,
                        ), // Calendar end date
                        focusedDay: focused, // Currently displayed month/year
                        // Header styling (month/year display and navigation arrows)
                        headerStyle: HeaderStyle(
                          formatButtonVisible:
                              false, // Hide week/month format toggle
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
                            color: fblaGold.withOpacity(
                              0.1,
                            ), // Light gold background
                          ),
                        ),
                        // Day cell styling
                        calendarStyle: CalendarStyle(
                          // Today's date styling (gold circle)
                          todayDecoration: BoxDecoration(
                            color: fblaGold,
                            shape: BoxShape.circle,
                          ),
                          // Selected date styling (navy circle)
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
                          // Weekend dates in red
                          weekendTextStyle: TextStyle(
                            color: Colors.red[400],
                          ),
                        ),
                        // Day of week labels (Mon, Tue, etc.)
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
                        availableGestures:
                            AvailableGestures.all, // Allow swipe navigation
                        // Determine if a day should be highlighted as selected
                        selectedDayPredicate: (day) => isSameDay(day, selected),
                        // Handle day selection
                        onDaySelected: (selectedDate, focusedDate) {
                          setState(() {
                            selected = selectedDate;
                            focused = focusedDate;
                          });
                        },
                      ),
                    ),
                  ),

                  // Filter Buttons Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // "All" filter button
                        Expanded(
                          child: _buildFilterButton(
                            "All",
                            Icons.calendar_month,
                            'all',
                          ),
                        ),
                        SizedBox(width: 8),
                        // "Today" filter button
                        Expanded(
                          child: _buildFilterButton(
                            "Today",
                            Icons.today,
                            'today',
                          ),
                        ),
                        SizedBox(width: 8),
                        // "Selected" filter button
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

          // ===== DRAGGABLE DIVIDER =====
          // User can drag up/down to resize the top and bottom sections
          GestureDetector(
            behavior: HitTestBehavior.opaque, // Entire area is draggable
            onPanUpdate: (details) {
              setState(() {
                // Adjust top height based on drag distance
                _topHeight += details.delta.dy;
                // Clamp to prevent sections from becoming too small
                // Min: 200px for calendar, Max: screen height - 270px for events list
                _topHeight = _topHeight.clamp(200.0, screenHeight - 270.0);
              });
            },
            child: Container(
              width: double.infinity,
              height: 38,
              color: fblaGold, // Gold bar for visibility
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Drag handle icon
                  Icon(
                    Icons.drag_handle_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 22,
                  ),
                  SizedBox(height: 2),
                  // Instruction text
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

          // ===== BOTTOM SECTION - EVENTS LIST =====
          // Expanded to fill remaining screen space
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  // Events header with count badge
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
                        // Badge showing number of filtered events
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

                  // Events List or Empty State
                  Expanded(
                    child: _filteredCalendars.isEmpty
                        ? // Empty state when no events match filter
                          Center(
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
                        : // Scrollable list of event cards
                          ListView.builder(
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

  /// Builds a filter button with icon and label
  /// Highlights the button if it matches the current filter mode
  ///
  /// [label] - Text to display on the button
  /// [icon] - Icon to show before the label
  /// [mode] - The filter mode this button represents
  Widget _buildFilterButton(String label, IconData icon, String mode) {
    final isSelected = _filterMode == mode;
    return Container(
      height: 44,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _filterMode = mode; // Update filter mode
          });
        },
        style: ElevatedButton.styleFrom(
          // Inverted colors when selected: navy background, white text
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
                overflow: TextOverflow.ellipsis, // Truncate if too long
              ),
            ),
          ],
        ),
      ),
    );
  }
}
