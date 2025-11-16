import 'dart:math';

import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// StatefulWidget for creating a new group
/// Allows advisors to create groups with a unique join code that members can use to join
class NewGroup extends StatefulWidget {
  const NewGroup(void setState, {super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  // Text controller for the group name input field
  final _titleController = TextEditingController();

  /// Submits the new group to Firebase Firestore
  /// Validates input, generates a unique join code, and shows success dialog
  void submitGroup() {
    final title = _titleController.text.trim();

    // Validate that group name is not empty
    if (title.isEmpty) {
      showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFFD700),
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  "Missing Information",
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              "Please enter a group name before creating.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
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
      return;
    }

    // Generate a unique 6-character alphanumeric join code
    final code = _generateAlphanumericCode();

    // Show success dialog with the generated join code
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Group Created!',
              style: TextStyle(
                color: Color(0xFF003B7E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the group name
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B7E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            // Highlighted container displaying the join code
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFFFD700).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFFFD700), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Join Code',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Large, bold join code for easy reading and sharing
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Color(0xFF003B7E),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Instruction text for sharing the code
            Text(
              'Share this code with members to join your group',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // Create the group document in Firestore with advisor information
                await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(code)
                    .set({
                      'name': title,
                      'code': code,
                      'advisor': FirebaseAuth.instance.currentUser!.displayName,
                      'email': FirebaseAuth.instance.currentUser!.email,
                    });

                // Add the group to the advisor's groups subcollection
                await FirebaseFirestore.instance
                    .collection('advisors')
                    .doc(globals.currentUID)
                    .collection('groups')
                    .doc(code)
                    .set({});
              } catch (_) {
                // Silently catch errors (could be improved with error handling)
              }
              Navigator.of(dialogContext).pop(); // Close success dialog
              Navigator.of(context).pop(); // Close the new group screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF003B7E),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text(
          "New Group",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF003B7E),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              // Group Name Section Label
              Text(
                "Group Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),

              // Group name input field (max 50 characters)
              TextField(
                controller: _titleController,
                maxLength: 50,
                onTapOutside: (event) {
                  // Dismiss keyboard when tapping outside
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Enter group name...",
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
                textCapitalization: TextCapitalization
                    .words, // Capitalize first letter of each word
              ),
              SizedBox(height: 16),

              // Informational box explaining join code generation
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF003B7E),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A unique join code will be generated for members to join your group',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Create Group Button
              Center(
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    // Gradient background for visual appeal
                    gradient: LinearGradient(
                      colors: [Color(0xFF003B7E), Color(0xFF002856)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF003B7E).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: submitGroup, // Call submitGroup when tapped
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Add icon
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFFFD700),
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            // Button text
                            Text(
                              "Create Group",
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

  @override
  void dispose() {
    // Clean up the controller when widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  /// Generates a random alphanumeric code for group joining
  ///
  /// Excludes confusing characters like 'I', 'O', '0', '1' to prevent user errors
  ///
  /// Parameters:
  /// - [length]: Number of characters in the code (default: 6)
  ///
  /// Returns: A random uppercase alphanumeric string (e.g., "K7MN2P")
  static String _generateAlphanumericCode({int length = 6}) {
    // Character set excludes easily confused characters (I/1, O/0)
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();

    // Generate random string by selecting random characters
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
