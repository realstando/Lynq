import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/Annoucements/announcements_page.dart';
import 'package:coding_prog/Homepage/home_page.dart';
import 'package:coding_prog/SocialMedia/Youtube/youtube_screen.dart';
import 'package:coding_prog/SocialMedia/Instagram/instagram_page.dart';
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
import 'globals.dart' as globals;
import 'package:coding_prog/SocialMedia/mediahub.dart';

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
  bool isLoading = true;

  StreamSubscription? _userSubs;
  final Map<String, StreamSubscription> _groupListeners = {};
  final Map<String, StreamSubscription> _announcementListeners = {};
  final Map<String, StreamSubscription> _calendarListeners = {}; 

  List<Widget> get _pages {
    List<Widget> pages = [
      HomePage(onNavigate: _navigateBar),
      AnnouncementsPage(onNavigate: _navigateBar),
      EventsPage(onNavigate: _navigateBar),
      CalendarPage(onNavigate: _navigateBar),
      ResourcePage(onNavigate: _navigateBar),
      ProfilePage(onNavigate: _navigateBar),
      GroupPage(onNavigate: _navigateBar),
      SocialMediaHub(onNavigate: _navigateBar),
      InstagramHomePage(onNavigate: _navigateBar),
      YouTubeScreen(onNavigate: _navigateBar),
      AdminPage(onNavigate: _navigateBar)
    ];

    if (globals.isAdmin == true) {
      setState(() {
        pages.insert(10, AdminPage(onNavigate: _navigateBar)); // Adds admin page
      });
    }

    return pages;
  }


  @override
  void initState() {
    super.initState();
    
    // Wrap in try-catch to prevent crashes
    try {
      _fetchUser();
    } catch (e) {
      print('Error in initState: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    stopListeningToUserData();
    super.dispose();
  }

  void _navigateBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // final List<Announcement> _announcements = [
  //   Announcement(
  //     initial: "WA",
  //     name: "Washington FBLA",
  //     title: "Time Change for Network Design",
  //     date: DateTime(2025, 4, 25, 13, 21),
  //     content:
  //         "Hey students! There will be a time change for the roleplay event Network Design due to scheduling conflicts. Thanks for understanding!",
  //   ),
  //   Announcement(
  //     initial: "GA",
  //     name: "Georgia FBLA",
  //     title: "Time Change for MIS",
  //     date: DateTime(2025, 4, 25, 13, 21),
  //     content:
  //         "Hey students! There will be a time change for the roleplay event MIS due to scheduling conflicts. Thanks for understanding!",
  //   ),
  // ];

  // final List<Calendar> _calendars = [
  //   Calendar(
  //     "Washington SBLC",
  //     DateTime.utc(2026, 4, 26),
  //     "Bellevue Washington",
  //   ),
  //   Calendar(
  //     "Anaheim NLC",
  //     DateTime.utc(2026, 6, 26),
  //     "Anaheim California",
  //   ),
  // ];

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

  Future<void> _fetchUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Initialize user data
      globals.currentUID = FirebaseAuth.instance.currentUser?.uid;
      globals.currentUserName = FirebaseAuth.instance.currentUser?.displayName ?? '';
      globals.currentUserEmail = FirebaseAuth.instance.currentUser?.email;
      globals.groups = []; // Initialize groups list

      // Set default name if empty
      if (globals.currentUserName == null || globals.currentUserName!.isEmpty) {
        globals.currentUserName = 'User';
      }
      // Fetch user role from Firestore
      await _fetchUserRole();

      // Special case for admin email
      if (globals.currentUserEmail == "rryanwwang@gmail.com") {
        globals.currentUserRole = 'advisors';
      }
      if (globals.currentUserEmail == "rryanwwang@gmail.com" || globals.currentUserEmail == "gordon.zhang090321@gmail.com") {
        globals.isAdmin = true;
        print("admin");
      }

      print('User Name: ${globals.currentUserName}');
      print('User Role: ${globals.currentUserRole}');
      print('User UID: ${globals.currentUID}');

      // Only listen to groups if user role and UID are set
      if (globals.currentUserRole != null && globals.currentUID != null) {
        _listenToUserData();
      } else {
        print('ERROR: User role or UID is null - cannot listen to groups');
      }

      print('Groups initialized: ${globals.groups}');
    } catch (e) {
      print('Error in _fetchUser: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print('ERROR: UID is null in _fetchUserRole');
        return;
      }

      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get();

      if (studentDoc.exists) {
        globals.currentUserRole = 'students';
        return;
      }

      final advisorDoc = await FirebaseFirestore.instance
          .collection('advisors')
          .doc(uid)
          .get();

      if (advisorDoc.exists) {
        globals.currentUserRole = 'advisors';
        return;
      }

      print('WARNING: User not found in students or advisors collection');
    } catch (e) {
      print('Error in _fetchUserRole: $e');
    }
  }

  void _listenToUserData() {
    stopListeningToUserData();

    final firestore = FirebaseFirestore.instance;

    // Ensure globals.groups is initialized
    globals.groups ??= [];

    _userSubs = firestore
        .collection(globals.currentUserRole!)
        .doc(globals.currentUID)
        .collection('groups')
        .snapshots()
        .listen(
          (userGroupsSnapshot) {
            try {
              final groupCodes = userGroupsSnapshot.docs.map((d) => d.id).toSet();

              // Remove listeners for groups the user left
              _groupListeners.keys
                  .where((code) => !groupCodes.contains(code))
                  .toList()
                  .forEach((code) {
                _groupListeners.remove(code)?.cancel();
                _announcementListeners.remove(code)?.cancel();
                _calendarListeners.remove(code)?.cancel();
                setState(() {
                  globals.groups?.removeWhere((g) => g['code'] == code);
                  globals.announcements?.removeWhere((a) => a['code'] == code);
                  globals.calendar?.removeWhere((a) => a['code'] == code);
                });
              });

              // Add listeners for new groups
              for (final code in groupCodes.where((c) => !_groupListeners.containsKey(c))) {
                _groupListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .snapshots()
                    .listen(
                      (groupDoc) {
                        try {
                          _updateGroupData(code, groupDoc.data());
                        } catch (e) {
                          print('Error updating group $code: $e');
                        }
                      },
                      onError: (error) {
                        print('Error listening to group $code: $error');
                      },
                      cancelOnError: false,
                    );
                _announcementListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('announcements')
                    .orderBy('date', descending: true) // Most recent first
                    .snapshots()
                    .listen(
                      (announcementsSnapshot) {
                        try {
                          _updateGroupAnnouncements(code, announcementsSnapshot);
                        } catch (e) {
                          print('Error updating announcements for group $code: $e');
                        }
                      },
                      onError: (error) {
                        print('Error listening to announcements for group $code: $error');
                      },
                      cancelOnError: false,
                    );
                _calendarListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('calendar')
                    .orderBy('date', descending: true) // Most recent first
                    .snapshots()
                    .listen(
                      (calendarSnapshot) {
                        try {
                          _updateGroupCalendar(code, calendarSnapshot);
                        } catch (e) {
                          print('Error updating calendar for group $code: $e');
                        }
                      },
                      onError: (error) {
                        print('Error listening to calendar for group $code: $error');
                      },
                      cancelOnError: false,
                    );
              }
            } catch (e) {
              print('Error processing user groups: $e');
            }
          },
          onError: (error) {
            print('Error listening to user groups: $error');
            setState(() {
              isLoading = false;
            });
          },
          cancelOnError: false,
        );
  }

  void _updateGroupData(String code, Map<String, dynamic>? groupData) {
    if (groupData != null) {
      setState(() {
        groupData['code'] = code;

        globals.groups ??= [];

        final existingIndex = globals.groups!.indexWhere((g) => g['code'] == code);
        if (existingIndex != -1) {
          globals.groups![existingIndex] = groupData;
        } else {
          globals.groups!.add(groupData);
        }
      });

      print('Updated group: $code');
    } else {
      setState(() {
        globals.groups?.removeWhere((g) => g['code'] == code);
      });
      print('Group $code deleted');
    }
  }

  void _updateGroupAnnouncements(String code, QuerySnapshot announcementsSnapshot) {
    setState(() {
      globals.announcements ??= [];

      // Remove old announcements for this group
      globals.announcements!.removeWhere((a) => a['code'] == code);

      // Find the group to get its name
      final group = globals.groups?.firstWhere(
        (g) => g['code'] == code,
        orElse: () => {'name': 'Unknown Group'},
      );
      final name = group?['name']?.toString() ?? 'Unknown Group';
      print('Group name for $code: $name');

      // Add new announcements for this group
      for (var doc in announcementsSnapshot.docs) {
        final announcementData = doc.data() as Map<String, dynamic>;
        announcementData['id'] = doc.id; // Store document ID
        announcementData['code'] = code; // Store which group this is from
        announcementData['name'] = name; 

        globals.announcements!.add(announcementData);
      }

      // Sort all announcements by date (most recent first)
      globals.announcements!.sort((a, b) {
        final aDate = (a['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        final bDate = (b['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    });

    print('Updated ${announcementsSnapshot.docs.length} announcements for group $code');
  }

  void _updateGroupCalendar(String code, QuerySnapshot calendarSnapshot) {
    setState(() {
      globals.calendar ??= [];

      // Remove old calendar for this group
      globals.calendar!.removeWhere((a) => a['code'] == code);

      // Find the group to get its name
      final group = globals.groups?.firstWhere(
        (g) => g['code'] == code,
        orElse: () => {'name': 'Unknown Group'},
      );
      final name = group?['name']?.toString() ?? 'Unknown Group';
      print('Group name for $code: $name');

      // Add new calendar for this group
      for (var doc in calendarSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store document ID
        data['code'] = code; // Store which group this is from
        data['name'] = name;

        globals.calendar!.add(data);
      }

      // Sort all calendar by date (most recent first)
      globals.calendar!.sort((a, b) {
        final aDate = (a['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        final bDate = (b['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    });

    print('Updated ${calendarSnapshot.docs.length} calendar for group $code');
  }

  void stopListeningToUserData() {
    _userSubs?.cancel();
    _userSubs = null;
    for (var sub in _groupListeners.values) {
      sub.cancel();
    }
    _groupListeners.clear();
    for (var sub in _announcementListeners.values) {
      sub.cancel();
    }
    _calendarListeners.clear();
    for (var sub in _calendarListeners.values) {
      sub.cancel();
    }
    _calendarListeners.clear();
  }
}