import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
// import 'package:coding_prog/Annoucements/announcement.dart';

/// Form page for creating and posting new announcements to FBLA groups
/// Features group selection dropdown, title input, and multi-line content area
/// Validates input and saves announcements to Firestore with timestamp
/// Note: Constructor signature appears incomplete (accepts unused param0)
class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement(Null Function() param0, {super.key});
  // final void Function(Announcement announcement) addAnnouncement;

  @override
  State<NewAnnouncement> createState() {
    return _NewAnnouncementState();
  }
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  /// Controller for the announcement title/subject input field
  /// Max length: 75 characters
  final _titleController = TextEditingController();

  /// Controller for the announcement content/body input field
  /// Max length: 500 characters, multi-line
  final _informationController = TextEditingController();

  /// The currently selected group from the dropdown
  /// Format: "Group Name (code)" - code is extracted for Firestore document ID
  String? selectedValue;

  /// Generates list of group options for the dropdown
  /// Combines group name and code for display: "Chapter Name (ABC123)"
  /// Returns empty list if no groups are available in global state
  List<String> get groupItems {
    if (globals.groups.isEmpty) {
      return [];
    }
    // Map each group to a formatted string with name and code
    return globals.groups.map((group) {
      final name = group.name.toString();
      final code = group.code.toString();
      return '$name ($code)'; // Format: "Washington FBLA (WA2025)"
    }).toList();
  }

  /// Clean up text controllers when widget is disposed to prevent memory leaks
  @override
  void dispose() {
    _titleController.dispose();
    _informationController.dispose();
    super.dispose();
  }

  /// Validates and submits the announcement to Firestore
  /// Shows error dialog if required fields are empty
  /// Extracts group code from selectedValue and saves to that group's announcements collection
  void _submitExpense() async {
    // Validate that both title and content are filled
    if (_titleController.text.trim().isEmpty ||
        _informationController.text.trim().isEmpty) {
      // Show validation error dialog
      showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Dialog title with warning icon
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFFD700), // Gold warning icon
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  "Missing Information",
                  style: TextStyle(
                    color: Color(0xFF003B7E), // Navy blue
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Error message
            content: Text(
              "Please fill in both the title and announcement content before posting.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF003B7E),
                ),
                child: Text(
                  "Got it!",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        }),
      );
      return; // Stop submission if validation fails
    }

    try {
      // Extract group code from selectedValue
      // selectedValue format: "Group Name (CODE)" -> extract "CODE"
      // This code is used as the Firestore document ID for the group
      print(
        selectedValue!.substring(
          selectedValue!.indexOf("(") + 1, // Start after opening parenthesis
          selectedValue!.indexOf(")"), // End before closing parenthesis
        ),
      );

      // Save announcement to Firestore
      // Path: groups/{groupCode}/announcements/{auto-generated-id}
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(
            selectedValue!.substring(
              selectedValue!.indexOf("(") + 1,
              selectedValue!.indexOf(")"),
            ),
          )
          .collection('announcements')
          .doc(_titleController.text.trim())
          .set({
            'title': _titleController.text.trim(),
            'content': _informationController.text.trim(),
            'date': DateTime.now(), // Timestamp for sorting announcements
          });

      // Close the form page after successful submission
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      // Silent error handling
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      // App bar with navy blue theme
      appBar: AppBar(
        title: Text(
          "New Announcement",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF003B7E), // FBLA Navy
        elevation: 0, // Flat design
      ),
      backgroundColor: Colors.grey[50],
      // Scrollable form to handle keyboard overlap on small screens
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              // ===== GROUP SELECTION SECTION =====
              // Label for dropdown
              Text(
                "Group",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Dropdown to select which group receives the announcement
              DropdownButtonFormField<String>(
                initialValue: selectedValue,
                hint: Text(
                  'Select a group',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                // Populate dropdown with formatted group names and codes
                items: groupItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                // Update state when selection changes
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                // Consistent input styling throughout the form
                decoration: InputDecoration(
                  hintText: 'Select a group',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  // Navy blue border when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // ===== TITLE/SUBJECT SECTION =====
              // Label for title field
              Text(
                "Subject",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Single-line text field for announcement title
              TextField(
                controller: _titleController,
                maxLength: 75, // Limit title length
                // Dismiss keyboard when tapping outside
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Enter announcement title...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  counter: Offstage(), // Hide character counter
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // ===== CONTENT SECTION =====
              // Label for content field
              Text(
                "Content",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Multi-line text field for announcement body
              TextField(
                controller: _informationController,
                maxLength: 500, // Limit content length
                maxLines: 8, // Allow multiple lines for content
                // Dismiss keyboard when tapping outside
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Write your announcement here...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  counter: Offstage(), // Hide character counter
                  contentPadding: EdgeInsets.all(16),
                  alignLabelWithHint:
                      true, // Keep hint aligned at top for multiline
                ),
              ),
              SizedBox(height: 40),

              // ===== SUBMIT BUTTON =====
              // Full-width button with gradient background and shadow
              Center(
                child: Container(
                  width: double.infinity,
                  height: 56,
                  // Gradient background for visual appeal
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF003B7E), Color(0xFF002856)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    // Drop shadow for depth
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF003B7E).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  // Material wrapper for ripple effect
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _submitExpense, // Submit form on tap
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        // Button content: icon + text
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                              color: Color(0xFFFFD700), // Gold send icon
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Post Announcement",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
