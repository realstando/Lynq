import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/Annoucements/announcements_page.dart';
import 'package:coding_prog/Groups/admin_group_page.dart';
import 'package:coding_prog/Homepage/home_page.dart';
import 'package:coding_prog/admin/admin_page.dart';
import 'package:coding_prog/login/signup_page.dart';
import 'package:coding_prog/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/login/login_page.dart';
import 'package:coding_prog/Competive_Events/events_page.dart';
import 'package:coding_prog/Resources/resource_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:coding_prog/Resources/AdminResources/resources_adminpage.dart';
import 'package:coding_prog/Calendar/calendar_page.dart';
import 'package:coding_prog/Calendar/AdminCalendar/calendar_adminpage.dart';
import 'package:coding_prog/Resources/resource_page.dart';
import 'package:coding_prog/Homepage/admin_home_page.dart';
import 'package:coding_prog/Calendar/calendar_page.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:coding_prog/Calendar/calendar.dart';
import 'package:coding_prog/Groups/group_page.dart';
import 'package:coding_prog/Groups/group.dart';
import 'package:coding_prog/Groups/admin_group_page.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LYNQ',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/login/': (context) => const LoginPage(),
        '/signup/': (context) => const SignupPage(),
        '/home/': (context) => const MainScaffold(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // User is logged in
        if (snapshot.hasData) {
          return const MainScaffold();
        }

        // User is not logged in
        return const LoginPage();
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  bool isLoading = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        onNavigate: _navigateBar,
        announcements: _announcements,
        calendars: _calendars,
      ),
      AnnouncementsPage(
        onNavigate: _navigateBar,
        announcements: _announcements,
        onAddAnnouncement: _addAnnouncement,
      ),
      EventsPage(
        onNavigate: _navigateBar,
      ),
      CalendarPage(
        onNavigate: _navigateBar,
        calendars: _calendars,
        onAddCalendar: _addCalendar,
      ),
      ResourcePage(onNavigate: _navigateBar),
      ProfilePage(
        onNavigate: _navigateBar,
      ),
      GroupPage(onNavigate: _navigateBar),
    ];
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    globals.currentUserName = FirebaseAuth.instance.currentUser?.displayName ?? "Member";
    globals.currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    print("User Name: ${globals.currentUserName}  hi");
    if (uid != null) {
      final studentDoc = await FirebaseFirestore.instance.collection('students').doc(uid).get();
      if (studentDoc.exists) {
        setState(() {
          globals.currentUserRole = 'student';
          isLoading = false;
        });
        return;
      }
      final advisorDoc = await FirebaseFirestore.instance.collection('advisors').doc(uid).get();
      if (advisorDoc.exists) {
        setState(() {
          globals.currentUserRole = 'advisor';
          isLoading = false;
        });
        return;
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addAnnouncement(Announcement announcement) {
    setState(() {
      _announcements.insert(0, announcement);
    });
  }

  void _addCalendar(Calendar calendar) {
    setState(() {
      _calendars.insert(0, calendar);
    });
  }

  final List<Announcement> _announcements = [
    Announcement(
      initial: "WA",
      name: "Washington FBLA",
      title: "Time Change for Network Design",
      date: DateTime(2025, 4, 25, 13, 21),
      content:
          "Hey students! There will be a time change for the roleplay event Network Design due to scheduling conflicts. Thanks for understanding!",
    ),
    Announcement(
      initial: "GA",
      name: "Georgia FBLA",
      title: "Time Change for MIS",
      date: DateTime(2025, 4, 25, 13, 21),
      content:
          "Hey students! There will be a time change for the roleplay event MIS due to scheduling conflicts. Thanks for understanding!",
    ),
  ];

  final List<Calendar> _calendars = [
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _selectedIndex > 3
                ? 0
                : _selectedIndex, // Clamp to 0-3
            onDestinationSelected: _navigateBar,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: const Color(0xFF0A2E7F),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            height: 65,
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            animationDuration: const Duration(milliseconds: 400),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  size: 24,
                  color: Colors.grey[600],
                ),
                selectedIcon: const Icon(
                  Icons.home_rounded,
                  size: 26,
                  color: Colors.white,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.campaign_outlined,
                  size: 24,
                  color: Colors.grey[600],
                ),
                selectedIcon: const Icon(
                  Icons.campaign_rounded,
                  size: 26,
                  color: Colors.white,
                ),
                label: 'Announcements',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.event_outlined,
                  size: 24,
                  color: Colors.grey[600],
                ),
                selectedIcon: const Icon(
                  Icons.event_rounded,
                  size: 26,
                  color: Colors.white,
                ),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.menu_book_outlined,
                  size: 24,
                  color: Colors.grey[600],
                ),
                selectedIcon: const Icon(
                  Icons.calendar_month,
                  size: 26,
                  color: Colors.white,
                ),
                label: 'Calendar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
