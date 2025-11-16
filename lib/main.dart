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
      home: const AuthWrapper(), // Start with auth check
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
          return Scaffold(
            backgroundColor: const Color(0xFF0A2E7F), // FBLA Navy
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo container
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
                  // Loading indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFF4AB19), // FBLA Gold
                    ),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 24),
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

        // User is logged in - show main app
        if (snapshot.hasData) {
          return const MainScaffold();
        }

        // User is not logged in - show login page
        return const LoginPage();
      },
    );
  }
}

/// Main scaffold containing navigation and page management
/// Handles bottom navigation bar and page switching
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0; // Currently selected navigation index
  bool isLoading = true; // Loading state for initial data fetch

  // Stream subscriptions for real-time Firestore updates
  StreamSubscription? _userSubs; // User groups subscription
  final Map<String, StreamSubscription> _groupListeners =
      {}; // Group data listeners
  final Map<String, StreamSubscription> _announcementListeners =
      {}; // Announcement listeners
  final Map<String, StreamSubscription> _calendarListeners =
      {}; // Calendar event listeners
  final Map<String, StreamSubscription> _resourcesListeners =
      {}; // Resources listeners

  /// Returns list of all available pages in the app
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

    // Add admin page if user is an admin
    if (globals.isAdmin == true) {
      setState(() {
        pages.insert(
          10,
          AdminPage(onNavigate: _navigateBar),
        );
      });
    }

    return pages;
  }

  @override
  void initState() {
    super.initState();

    // Fetch user data on initialization with error handling
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
    // Clean up all listeners and global data
    stopListeningToUserData();
    globals.currentUID = null;
    globals.currentUserName = null;
    globals.currentUserRole = null;
    globals.currentUserEmail = null;
    globals.isAdmin = false;
    super.dispose();
  }

  /// Navigation callback for switching between pages
  void _navigateBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while fetching initial user data
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A2E7F),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFF4AB19),
                ),
                strokeWidth: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                'Setting up your experience...',
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

    // Main app scaffold with bottom navigation
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
                // Clamp selected index to 0-3 for bottom nav items
                selectedIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
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
                  // Home tab
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
      setState(() {
        isLoading = true;
      });

      // Initialize basic user data from Firebase Auth
      globals.currentUID = FirebaseAuth.instance.currentUser?.uid;
      globals.currentUserName =
          FirebaseAuth.instance.currentUser?.displayName ?? '';
      globals.currentUserEmail = FirebaseAuth.instance.currentUser?.email;
      globals.groups = [];

      // Set default name if empty
      if (globals.currentUserName == null || globals.currentUserName!.isEmpty) {
        globals.currentUserName = 'User';
      }

      // Fetch user role from Firestore (student or advisor)
      await _fetchUserRole();

      // Special admin role override for specific email
      if (globals.currentUserEmail == "rryanwwang@gmail.com") {
        globals.currentUserRole = 'advisors';
      }

      // Set admin flag for specific emails
      if (globals.currentUserEmail == "rryanwwang@gmail.com" ||
          globals.currentUserEmail == "gordon.zhang090321@gmail.com") {
        globals.isAdmin = true;
        print("admin");
      }

      print('User Name: ${globals.currentUserName}');
      print('User Role: ${globals.currentUserRole}');
      print('User UID: ${globals.currentUID}');

      // Start listening to user's events and groups if role and UID are set
      if (globals.currentUserRole != null && globals.currentUID != null) {
        // Listen to user's events
        FirebaseFirestore.instance
            .collection(globals.currentUserRole!)
            .doc(globals.currentUID)
            .collection('events')
            .snapshots()
            .listen((snapshot) {
              setState(() {
                globals.events = snapshot.docs.map((doc) => doc.id).toList();
              });
            });
        print("Events: " + globals.events.toString());

        // Start listening to all user data
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

  /// Fetches user role from Firestore
  /// Checks both 'students' and 'advisors' collections
  Future<void> _fetchUserRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print('ERROR: UID is null in _fetchUserRole');
        return;
      }

      // Check if user exists in students collection
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get();

      if (studentDoc.exists) {
        globals.currentUserRole = 'students';
        return;
      }

      // Check if user exists in advisors collection
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

  /// Sets up real-time listeners for user's groups and associated data
  /// Listens to: groups, announcements, calendar events, and resources
  void _listenToUserData() {
    // Cancel any existing listeners first
    stopListeningToUserData();

    final firestore = FirebaseFirestore.instance;

    // Ensure globals.groups is initialized
    globals.groups ??= [];

    // Listen to user's groups collection
    _userSubs = firestore
        .collection(globals.currentUserRole!)
        .doc(globals.currentUID)
        .collection('groups')
        .snapshots()
        .listen(
          (userGroupsSnapshot) {
            try {
              // Get set of all group codes user belongs to
              final groupCodes = userGroupsSnapshot.docs
                  .map((d) => d.id)
                  .toSet();

              // Remove listeners for groups the user left
              _groupListeners.keys
                  .where((code) => !groupCodes.contains(code))
                  .toList()
                  .forEach((code) {
                    // Cancel all listeners for this group
                    _groupListeners.remove(code)?.cancel();
                    _announcementListeners.remove(code)?.cancel();
                    _calendarListeners.remove(code)?.cancel();
                    _resourcesListeners.remove(code)?.cancel();

                    // Remove data from global state
                    setState(() {
                      globals.groups?.removeWhere((g) => g['code'] == code);
                      globals.announcements?.removeWhere(
                        (a) => a['code'] == code,
                      );
                      globals.calendar?.removeWhere((a) => a['code'] == code);
                      globals.resources?.removeWhere((a) => a['code'] == code);
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
                      onError: (error) {
                        print('Error listening to group $code: $error');
                      },
                      cancelOnError: false,
                    );

                // Listen to group announcements
                _announcementListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('announcements')
                    .orderBy('date', descending: true) // Most recent first
                    .snapshots()
                    .listen(
                      (announcementsSnapshot) {
                        try {
                          _updateGroupAnnouncements(
                            code,
                            announcementsSnapshot,
                          );
                        } catch (e) {
                          print(
                            'Error updating announcements for group $code: $e',
                          );
                        }
                      },
                      onError: (error) {
                        print(
                          'Error listening to announcements for group $code: $error',
                        );
                      },
                      cancelOnError: false,
                    );

                // Listen to group calendar events
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
                        print(
                          'Error listening to calendar for group $code: $error',
                        );
                      },
                      cancelOnError: false,
                    );

                // Listen to group resources
                _resourcesListeners[code] = firestore
                    .collection('groups')
                    .doc(code)
                    .collection('resources')
                    .snapshots()
                    .listen(
                      (resourcesSnapshot) {
                        try {
                          _updateGroupresources(code, resourcesSnapshot);
                        } catch (e) {
                          print('Error updating resources for group $code: $e');
                        }
                      },
                      onError: (error) {
                        print(
                          'Error listening to resources for group $code: $error',
                        );
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

  /// Updates group data in global state
  /// Called when group document changes
  void _updateGroupData(String code, Map<String, dynamic>? groupData) {
    if (groupData != null) {
      setState(() {
        groupData['code'] = code;

        globals.groups ??= [];

        // Update existing group or add new one
        final existingIndex = globals.groups!.indexWhere(
          (g) => g['code'] == code,
        );
        if (existingIndex != -1) {
          globals.groups![existingIndex] = groupData;
        } else {
          globals.groups!.add(groupData);
        }
      });

      print('Updated group: $code');
    } else {
      // Group was deleted
      setState(() {
        globals.groups?.removeWhere((g) => g['code'] == code);
      });
      print('Group $code deleted');
    }
  }

  /// Updates group announcements in global state
  /// Called when announcements collection changes
  void _updateGroupAnnouncements(
    String code,
    QuerySnapshot announcementsSnapshot,
  ) {
    setState(() {
      globals.announcements ??= [];

      // Remove old announcements for this group
      globals.announcements!.removeWhere((a) => a['code'] == code);

      // Find the group name
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
        announcementData['name'] = name; // Store group name

        globals.announcements!.add(announcementData);
      }

      // Sort all announcements by date (most recent first)
      globals.announcements!.sort((a, b) {
        final aDate = (a['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        final bDate = (b['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    });

    print(
      'Updated ${announcementsSnapshot.docs.length} announcements for group $code',
    );
  }

  /// Updates group calendar events in global state
  /// Called when calendar collection changes
  void _updateGroupCalendar(String code, QuerySnapshot calendarSnapshot) {
    setState(() {
      globals.calendar ??= [];

      // Remove old calendar events for this group
      globals.calendar!.removeWhere((a) => a['code'] == code);

      // Find the group name
      final group = globals.groups?.firstWhere(
        (g) => g['code'] == code,
        orElse: () => {'name': 'Unknown Group'},
      );
      final name = group?['name']?.toString() ?? 'Unknown Group';
      print('Group name for $code: $name');

      // Add new calendar events for this group
      for (var doc in calendarSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store document ID
        data['code'] = code; // Store which group this is from
        data['name'] = name; // Store group name

        globals.calendar!.add(data);
      }

      // Sort all calendar events by date (most recent first)
      globals.calendar!.sort((a, b) {
        final aDate = (a['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        final bDate = (b['date'] as Timestamp?)?.toDate() ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    });

    print('Updated ${calendarSnapshot.docs.length} calendar for group $code');
  }

  /// Updates group resources in global state
  /// Called when resources collection changes
  void _updateGroupresources(String code, QuerySnapshot resourcesSnapshot) {
    setState(() {
      globals.resources ??= [];

      // Remove old resources for this group
      globals.resources!.removeWhere((a) => a['code'] == code);

      // Find the group name
      final group = globals.groups?.firstWhere(
        (g) => g['code'] == code,
        orElse: () => {'name': 'Unknown Group'},
      );
      final name = group?['name']?.toString() ?? 'Unknown Group';
      print('Group name for $code: $name');

      // Add new resources for this group
      for (var doc in resourcesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store document ID
        data['code'] = code; // Store which group this is from
        data['name'] = name; // Store group name

        globals.resources!.add(data);
      }
    });

    print('Updated ${resourcesSnapshot.docs.length} resources for group $code');
  }

  /// Cancels all active Firestore listeners
  /// Called on dispose to prevent memory leaks
  void stopListeningToUserData() {
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

    // Cancel all resources listeners
    for (var sub in _resourcesListeners.values) {
      sub.cancel();
    }
    _resourcesListeners.clear();
  }
}
