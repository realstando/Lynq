import 'dart:math';

import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewGroup extends StatefulWidget {
  const NewGroup(void setState, {super.key});
  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final _titleController = TextEditingController();

  // FBLA Colors
  static const Color fblaBlue = Color.fromARGB(255, 1, 26, 167);
  static const Color fblaDarkBlue = Color(0xFF1D52BC);
  static const Color fblaGold = Color(0xFFF4AB19);

  void submitGroup() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text('Please enter a group name'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final code = _generateAlphanumericCode();

    // Show success dialog with join code
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 28),
            ),
            SizedBox(width: 12),
            Text(
              'Group Created!',
              style: TextStyle(
                color: fblaDarkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: fblaDarkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: fblaGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: fblaGold, width: 2),
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
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                      color: fblaBlue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: fblaBlue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Share this code with members to join',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('groups').doc(code)
                    .set({
                      'name': title,
                      'advisor': FirebaseAuth.instance.currentUser!.displayName,
                      'email': FirebaseAuth.instance.currentUser!.email,
                    });
                await FirebaseFirestore.instance
                    .collection('advisors').doc(globals.currentUID)
                    .collection('groups').doc(code).set({});
              } catch (_) {
              }
              Navigator.of(dialogContext).pop(); // Close dialog
              Navigator.of(context).pop(); // Add the group
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: fblaBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create New Group'),
        backgroundColor: fblaBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),

              // Icon
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: fblaGold.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.group_add,
                  size: 80,
                  color: fblaGold,
                ),
              ),

              SizedBox(height: 32),

              // Title
              Text(
                'Create a New Group',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: fblaDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12),

              // Subtitle
              Text(
                'Enter a name for your FBLA chapter or group. A unique join code will be generated automatically.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // Input Card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: fblaBlue.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: fblaDarkBlue,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g., North Creek FBLA',
                        prefixIcon: Icon(Icons.group, color: fblaBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: fblaBlue, width: 2),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      autofocus: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Create Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: submitGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fblaBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Create Group',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Info Box
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: fblaBlue, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Members will use the generated join code to connect to your group',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
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

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  static String _generateAlphanumericCode({int length = 6}) {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Excludes confusing chars
    final random = Random();

    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
  
}

