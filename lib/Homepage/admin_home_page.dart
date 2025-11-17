import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Admin dashboard page for managing announcements
/// Allows administrators to create, view, and delete announcements
/// Features a floating action button for adding new announcements
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  /// List of announcements stored in memory
  /// Each announcement contains: title, content, and timestamp
  /// Note: This data is not persisted and will be lost when app restarts
  /// Consider using Firebase or local storage for production apps
  final List<Map<String, dynamic>> announcements = [
    {
      "title": "Washington FBLA",
      "content": "Time Change for Network Design",
      "date": DateTime(2025, 4, 25, 13, 21), // April 25, 2025 at 1:21 PM
    },
  ];

  /// Shows a dialog to add a new announcement
  /// Uses TextField widgets to capture title and content
  /// Validates that both fields are filled before adding
  void _addAnnouncement() {
    // Local variables to store user input
    String title = "";
    String content = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Announcement"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Don't take full screen height
            children: [
              // Title input field
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                onChanged: (val) => title = val, // Update title as user types
              ),
              // Content input field
              TextField(
                decoration: const InputDecoration(labelText: "Content"),
                onChanged: (val) =>
                    content = val, // Update content as user types
              ),
            ],
          ),
          actions: [
            // Cancel button - dismisses dialog without saving
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            // Add button - validates and saves announcement
            ElevatedButton(
              onPressed: () {
                // Only add if both fields have content
                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    announcements.add({
                      "title": title,
                      "content": content,
                      "date": DateTime.now(), // Timestamp when created
                    });
                  });
                  Navigator.pop(context); // Close dialog
                }
                // Note: No error message shown if fields are empty
                // Consider adding validation feedback for better UX
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  /// Deletes an announcement at the specified index
  /// Updates UI immediately by triggering a rebuild
  ///
  /// [index] - The position of the announcement in the list to remove
  void _deleteAnnouncement(int index) {
    setState(() {
      announcements.removeAt(index);
    });
    // Consider adding a confirmation dialog before deleting
    // or implementing an "undo" snackbar for better UX
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // App bar with title and blue theme
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // ListView allows scrolling when announcements exceed screen height
        child: ListView(
          children: [
            // Section header
            const Text(
              "Manage Announcements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Convert announcements list to Card widgets
            // Using asMap() to get both index and value for deletion
            ...announcements.asMap().entries.map((entry) {
              int index = entry.key; // Position in list (for deletion)
              var a = entry.value; // Announcement data

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ), // Space between cards
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: ListTile(
                  // Announcement title
                  title: Text(a["title"]),
                  // Content and formatted date/time
                  subtitle: Text(
                    "${a["content"]}\n${DateFormat("MMM d, yyyy • h:mm a").format(a["date"])}",
                    // Example output: "Apr 25, 2025 • 1:21 PM"
                  ),
                  isThreeLine:
                      true, // Allows subtitle to wrap to multiple lines
                  // Delete button on the right side
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAnnouncement(index),
                  ),
                ),
              );
            }),
          ],
        ),
      ),

      // Floating action button for adding new announcements
      // Fixed position at bottom-right of screen
      floatingActionButton: FloatingActionButton(
        onPressed: _addAnnouncement,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
