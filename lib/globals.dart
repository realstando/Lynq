import 'dart:ui';

import 'package:coding_prog/Annoucements/announcement.dart';
import 'package:coding_prog/Calendar/calendar.dart';
import 'package:coding_prog/Competive_Events/event.dart';
import 'package:coding_prog/Groups/group.dart';
import 'package:coding_prog/Resources/resource.dart';

// Identifiers of what the user is
late String currentUserRole;
bool isAdmin = false;
late String currentUserName;
late String currentUserEmail;
late String currentUID;

// List of group objects containing information (id, name, members, etc.)
List<Group> groups = [];
List<Announcement> announcements = [];
List<Calendar> calendar = [];
List<Resource> resources = [];
List<Event> events = [];
// FBLA brand colors
final fblaNavy = Color(0xFF0A2E7F);
final fblaGold = Color(0xFFF4AB19);
final fblaLightGold = Color(0xFFFFF4E0);
