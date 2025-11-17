import 'dart:ui';

// Identifiers of what the user is
String? currentUserRole;
bool? isAdmin;
String? currentUserName;
String? currentUserEmail;

String? currentUID;
// List of group objects containing information (id, name, members, etc.)
List<Map<String, dynamic>>? groups = [];
List<Map<String, dynamic>>? announcements = [];
List<Map<String, dynamic>>? calendar = [];
List<Map<String, dynamic>>? resources = [];
List<String>? events = [];
// FBLA brand colors
final fblaNavy = Color(0xFF0A2E7F);
final fblaGold = Color(0xFFF4AB19);
final fblaLightGold = Color(0xFFFFF4E0);
