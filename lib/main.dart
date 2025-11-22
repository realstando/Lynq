import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/Annoucements/announcements_page.dart';
import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:coding_prog/Calendar/calendar.dart';
import 'package:coding_prog/Competive_Events/event.dart';
import 'package:coding_prog/Groups/group.dart';
import 'package:coding_prog/Resources/resource.dart';
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
import 'package:coding_prog/Calendar/calendar_page.dart';
import 'package:coding_prog/Groups/group_page.dart';
import 'globals.dart' as globals;
import 'package:coding_prog/SocialMedia/mediahub.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Entry point of the application
/// Initializes Firebase and starts the app
Future<void> main() async {
  // Ensures Flutter bindings are initialized before Firebase
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start the Flutter app
  runApp(MyApp());
}

/// Root widget of the application
/// Sets up MaterialApp with routing and theme
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

/// Wrapper widget that handles authentication state
/// Shows appropriate screen based on user login status
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to Firebase auth state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading screen while checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }

        // User is logged in - show main app
        if (snapshot.hasData) {
          return MainScaffold(
            key: ValueKey(snapshot.data!.uid), // Force rebuild on user change
          );
        }

        // User is not logged in - show login page
        return const LoginPage();
      },
    );
  }
}

/// Main scaffold containing navigation and page management
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0; // Current page index
  bool isLoading = true; // Initial loading state

  // Firestore listeners for real-time data
  StreamSubscription? _userSubs;
  final Map<String, StreamSubscription> _groupListeners = {};
  final Map<String, StreamSubscription> _announcementListeners = {};
  final Map<String, StreamSubscription> _calendarListeners = {};
  final Map<String, StreamSubscription> _resourcesListeners = {};

  // Returns list of all app pages
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
      AdminPage(onNavigate: _navigateBar),
    ];

    // Add admin page if user is admin
    if (globals.isAdmin == true) {
      pages.insert(10, AdminPage(onNavigate: _navigateBar));
    }

    return pages;
  }

  @override
  void initState() {
    super.initState();
    try {
      _fetchUser(); // Load user data on start
    } catch (e) {
      print('Error in initState: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    stopListeningToUserData(); // Cancel all Firestore listeners
    // Clear global data
    globals.groups.clear();
    globals.announcements.clear();
    globals.calendar.clear();
    globals.resources.clear();
    globals.events.clear();
    super.dispose();
  }

  // Navigate to different page
  void _navigateBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while fetching user data
    if (isLoading) {
      return LoadingScreen();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NavigationBar(
                // Clamp to valid index, default to 0 if on other pages
                selectedIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
                onDestinationSelected: _navigateBar,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                // Hide indicator when not on main 4 pages
                indicatorColor: _selectedIndex <= 3 
                  ? const Color(0xFF0A2E7F) 
                  : Colors.transparent,
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 65,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                animationDuration: const Duration(milliseconds: 400),
                destinations: [
                  // Home tab
                  NavigationDestination(
                    icon: Icon(
                      Icons.home_outlined,
                      size: 24,
                      color: Colors.grey[600],
                    ),
                    selectedIcon: Icon(
                      // Show filled icon only when actually on Home
                      _selectedIndex == 0 && _selectedIndex <= 3 
                          ? Icons.home_rounded 
                          : Icons.home_outlined,
                      size: _selectedIndex == 0 && _selectedIndex <= 3 ? 26 : 24,
                      color: _selectedIndex == 0 && _selectedIndex <= 3 
                          ? Colors.white 
                          : Colors.grey[600],
                    ),
                    label: 'Home',
                  ),
                  // Announcements tab
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
                  // Events tab
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
                  // Calendar tab
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
            ],
          ),
        ),
      ),
    );
  }

  /// Fetches current user data from Firebase
  /// Initializes user role, groups, and starts real-time listeners
  Future<void> _fetchUser() async {
    try {
      // Set loading state
      setState(() {
        isLoading = true;
      });

      // Initialize user data from Firebase Auth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Store user info in globals
      globals.currentUID = currentUser.uid;
      globals.currentUserName = currentUser.displayName ?? 'User';
      globals.currentUserEmail = currentUser.email ?? '';

      // Fetch user role
      await _fetchUserRole();

      // Special admin overrides
      if (globals.currentUserEmail == "rryanwwang@gmail.com") {
        globals.currentUserRole = 'advisors';
      }
      if (globals.currentUserEmail == "rryanwwang@gmail.com" ||
          globals.currentUserEmail == "gordon.zhang090321@gmail.com") {
        globals.isAdmin = true;
        print("admin");
      } else {
        globals.isAdmin = false;
      }

      print('User Name: ${globals.currentUserName}');
      print('User Role: ${globals.currentUserRole}');
      print('User UID: ${globals.currentUID}');

      // Start listening to user data
      if (globals.currentUserRole.isNotEmpty && globals.currentUID.isNotEmpty) {
        // Listen to starred events
        FirebaseFirestore.instance
            .collection(globals.currentUserRole)
            .doc(globals.currentUID)
            .collection('events')
            .snapshots()
            .listen((snapshot) {
              setState(() {
                globals.events = snapshot.docs
                    .map((doc) => Event(name: doc.id))
                    .toList();
              });
            });

        _listenToUserData();
      } else {
        print('ERROR: User role or UID is empty');
      }
    } catch (e) {
      print('Error in _fetchUser: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Checks if user exists in students or advisors collection
  Future<void> _fetchUserRole() async {
    try {
      // Check students collection
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(globals.currentUID)
          .get();

      if (studentDoc.exists) {
        globals.currentUserRole = 'students';
        return;
      }

      // Check advisors collection
      final advisorDoc = await FirebaseFirestore.instance
          .collection('advisors')
          .doc(globals.currentUID)
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

  // Sets up real-time listeners for user's groups and related data
  void _listenToUserData() {
    stopListeningToUserData(); // Cancel existing listeners first

    final firestore = FirebaseFirestore.instance;

    // Listen to user's groups subcollection
    _userSubs = firestore
        .collection(globals.currentUserRole)
        .doc(globals.currentUID)
        .collection('groups')
        .snapshots()
        .listen(
          (userGroupsSnapshot) {
            try {
              // Get all group codes user belongs to
              final groupCodes = userGroupsSnapshot.docs
                  .map((d) => d.id)
                  .toSet();

              // Remove listeners for groups user left
              _groupListeners.keys
                  .where((code) => !groupCodes.contains(code))
                  .toList()
                  .forEach((code) {
                    // Cancel all listeners for this group
                    _groupListeners.remove(code)?.cancel();
                    _announcementListeners.remove(code)?.cancel();
                    _calendarListeners.remove(code)?.cancel();
                    _resourcesListeners.remove(code)?.cancel();

                    // Remove data from globals
                    setState(() {
                      globals.groups.removeWhere((g) => g.code == code);
                      globals.announcements.removeWhere((a) => a.code == code);
                      globals.calendar.removeWhere((c) => c.code == code);
                      globals.resources.removeWhere((r) => r.code == code);
                    });
                  });

              // Add listeners for new groups
              for (final code in groupCodes.where(
                (c) => !_groupListeners.containsKey(c),
              )) {
                // Listen to group document
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
                      onError: (error) =>
                          print('Error listening to group $code: $error'),
                      cancelOnError: false,
                    );

                // Listen to group's announcements
                _announcementListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('announcements')
                    .orderBy('date', descending: true)
                    .snapshots()
                    .listen(
                      (snapshot) {
                        try {
                          _updateGroupAnnouncements(code, snapshot);
                        } catch (e) {
                          print(
                            'Error updating announcements for group $code: $e',
                          );
                        }
                      },
                      onError: (error) => print(
                        'Error listening to announcements for group $code: $error',
                      ),
                      cancelOnError: false,
                    );

                // Listen to group's calendar events
                _calendarListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('calendar')
                    .orderBy('date', descending: true)
                    .snapshots()
                    .listen(
                      (snapshot) {
                        try {
                          _updateGroupCalendar(code, snapshot);
                        } catch (e) {
                          print('Error updating calendar for group $code: $e');
                        }
                      },
                      onError: (error) => print(
                        'Error listening to calendar for group $code: $error',
                      ),
                      cancelOnError: false,
                    );

                // Listen to group's resources
                _resourcesListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('resources')
                    .snapshots()
                    .listen(
                      (snapshot) {
                        try {
                          _updateGroupResources(code, snapshot);
                        } catch (e) {
                          print('Error updating resources for group $code: $e');
                        }
                      },
                      onError: (error) => print(
                        'Error listening to resources for group $code: $error',
                      ),
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

  // Updates group data in globals when Firestore changes
  void _updateGroupData(String code, Map<String, dynamic>? groupData) {
    if (groupData != null) {
      setState(() {
        final name = groupData['name']?.toString() ?? 'Unknown Group';
        final group = Group(name: name, code: code);

        // Update existing or add new group
        final existingIndex = globals.groups.indexWhere((g) => g.code == code);
        if (existingIndex != -1) {
          globals.groups[existingIndex] = group;
        } else {
          globals.groups.add(group);
        }
      });

      print('Updated group: $code');
    } else {
      // Group was deleted
      setState(() {
        globals.groups.removeWhere((g) => g.code == code);
      });
      print('Group $code deleted');
    }
  }

  // Updates announcements for a specific group
  void _updateGroupAnnouncements(String code, QuerySnapshot snapshot) {
    setState(() {
      // Remove old announcements for this group
      globals.announcements.removeWhere((a) => a.code == code);

      // Get group name
      final group = globals.groups.firstWhere(
        (g) => g.code == code,
        orElse: () => Group(name: 'Unknown Group', code: code),
      );

      // Add fresh announcements from Firestore
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['date'] as Timestamp?;

        final announcement = Announcement(
          name: group.name,
          title: data['title']?.toString() ?? 'No Title',
          content: data['content']?.toString() ?? '',
          date: timestamp?.toDate() ?? DateTime.now(),
          initial: group.name.isNotEmpty ? group.name[0].toUpperCase() : '?',
          code: code,
        );

        globals.announcements.add(announcement);
      }

      // Sort by most recent first
      globals.announcements.sort((a, b) => b.date.compareTo(a.date));
    });

    print('Updated ${snapshot.docs.length} announcements for group $code');
  }

  // Updates calendar events for a specific group
  void _updateGroupCalendar(String code, QuerySnapshot snapshot) {
    setState(() {
      // Remove old events for this group
      globals.calendar.removeWhere((c) => c.code == code);

      // Add fresh events from Firestore
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['date'] as Timestamp?;

        final calendarEvent = Calendar(
          data['event']?.toString() ?? 'No Title',
          timestamp?.toDate() ?? DateTime.now(),
          data['location']?.toString() ?? 'No Location',
          code,
        );

        globals.calendar.add(calendarEvent);
      }

      // Sort by most recent first
      globals.calendar.sort((a, b) => b.date.compareTo(a.date));
    });

    print('Updated ${snapshot.docs.length} calendar events for group $code');
  }

  // Updates resources for a specific group
  void _updateGroupResources(String code, QuerySnapshot snapshot) {
    setState(() {
      // Remove old resources for this group
      globals.resources.removeWhere((r) => r.code == code);

      // Add fresh resources from Firestore
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final resource = Resource(
          title: data['title']?.toString() ?? 'No Title',
          link: data['link']?.toString() ?? '',
          body: data['body']?.toString() ?? '',
          code: code,
        );

        globals.resources.add(resource);
      }
    });

    print('Updated ${snapshot.docs.length} resources for group $code');
  }

  // Cancels all Firestore listeners and clears data
  void stopListeningToUserData() {
    // Cancel main subscription
    _userSubs?.cancel();
    _userSubs = null;

    // Cancel all group listeners
    for (var sub in _groupListeners.values) {
      sub.cancel();
    }
    _groupListeners.clear();

    // Cancel all announcement listeners
    for (var sub in _announcementListeners.values) {
      sub.cancel();
    }
    _announcementListeners.clear();

    // Cancel all calendar listeners
    for (var sub in _calendarListeners.values) {
      sub.cancel();
    }
    _calendarListeners.clear();

    // Cancel all resource listeners
    for (var sub in _resourcesListeners.values) {
      sub.cancel();
    }
    _resourcesListeners.clear();

    // Clear all global data
    globals.groups.clear();
    globals.announcements.clear();
    globals.calendar.clear();
    globals.resources.clear();
    globals.events.clear();
  }
}

// Loading screen shown during authentication and data fetching
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2E7F), // FBLA Navy
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo container
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Image(
                  image: AssetImage('assets/Lynq_Logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Loading spinner
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFFF4AB19), // FBLA Gold
              ),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            // Loading text
            const Text(
              'Loading LYNQ...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}