import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/Calendar/calendar.dart';
import 'package:coding_prog/Calendar/calendar_card.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:coding_prog/Annoucements/announcement_format.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onNavigate,
  });

  final void Function(int) onNavigate;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Declaring the colors to be used for this screen
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  final String userName = globals.currentUserName ?? "Member";

  // Get the first 3 announcements (in order they appear in the list)
  List<Map<String, dynamic>> get recentAnnouncements {
    if (global.announcements == null || global.announcements!.isEmpty) {
      return [];
    }
    return global.announcements!.take(3).toList();
  }

  // Get all events in the current month
  List<Map<String, dynamic>> get monthEvents {
    if (global.calendar == null || global.calendar!.isEmpty) {
      return [];
    }

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Filter events in current month
    final filteredEvents = global.calendar!.where((cal) {
      return cal['date'].toDate().month == currentMonth &&
          cal['date'].toDate().year == currentYear;
    }).toList();

    // Sort by date (earliest first)
    filteredEvents.sort(
      (a, b) => a['date'].toDate().compareTo(b['date'].toDate()),
    );

    return filteredEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.menu_book_rounded,
        name: 'Home',
        color: Colors.black,
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Home',
        color: Colors.black,
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Creating the header for the home page
              Container(
                color: fblaNavy,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Centering the welcome text and icon
                  children: [
                    // The "Welcome back" text on the top of the home page
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // FBLA logo
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Image(
                            image: AssetImage('assets/Lynq_Logo.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Recent Announcements Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSectionHeader(
                      "Recent Announcements",
                      Icons.campaign,
                      () {
                        widget.onNavigate(1);
                      },
                    ),
                    const SizedBox(height: 14),
                    if (recentAnnouncements.isEmpty)
                      _buildEmptyState(
                        "No announcements yet",
                        "Check back later for updates!",
                      )
                    else
                      ...recentAnnouncements
                          .map((a) => _buildAnnouncementCard(a))
                          .toList(),
                    const SizedBox(height: 14),
                    _buildSecondaryButton(
                      "View All Announcements",
                      Icons.campaign,
                      () {
                        widget.onNavigate(1);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Events This Month Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSectionHeader(
                      "Events This Month",
                      Icons.event,
                      () {
                        widget.onNavigate(3);
                      },
                    ),
                    const SizedBox(height: 14),
                    if (monthEvents.isEmpty)
                      _buildEmptyState(
                        "No events this month",
                        "Stay tuned for upcoming events!",
                      )
                    else
                      ...monthEvents.map((e) => CalendarCard(e)).toList(),
                    const SizedBox(height: 14),
                    _buildPrimaryButton("View Calendar", Icons.event, () {
                      widget.onNavigate(3);
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo in empty state
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: fblaNavy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('assets/Lynq_Logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    const Color primaryBlue = Color(0xFF1D52BC);
    const Color gold = Color(0xFFFFD54F);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: primaryBlue,
                child: Text(
                  announcement['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            announcement['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.campaign,
                          color: primaryBlue,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      announcement['title'],
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: primaryBlue.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMd().format(
                            announcement['date'].toDate(),
                          ),
                          style: TextStyle(
                            color: primaryBlue.withOpacity(0.7),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    VoidCallback onViewAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Small logo icon next to section title
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: fblaNavy.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Image(
                  image: AssetImage('assets/Lynq_Logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: fblaNavy,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // Creating the "View All" button next to Announcements and Events
        GestureDetector(
          onTap: onViewAll, // Navigates to the announcement/calendar page
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              // Creates the background for the button
              color: fblaGold.withValues(
                alpha: 0.2,
              ), // FBLA Gold 20% transparent
              borderRadius: BorderRadius.circular(8),
              // Adds a slightly less bolded border
              border: Border.all(
                color: fblaGold.withValues(
                  alpha: 0.4,
                ), // FBLA Gold 40% transparent
              ),
            ),
            child: const Text(
              "View All",
              style: TextStyle(
                color: fblaNavy,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: fblaGold,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: fblaNavy,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: fblaNavy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
