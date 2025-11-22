import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/Groups/group.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget that displays a group card with branding and interactive elements
/// Shows group name, join code, and provides copy functionality
/// Designed with FBLA branding colors and modern Material Design principles
class GroupFormat extends StatelessWidget {

  final Group group;

  // FBLA Official Brand Colors for consistent styling
  static const Color fblaBlue = Color(0xFF1D52BC);
  static const Color fblaGold = Color(0xFFF4AB19);

  const GroupFormat(this.group, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Bottom margin to create spacing between multiple group cards
      margin: EdgeInsets.only(bottom: 12),
      // Container styling with FBLA blue theme
      decoration: BoxDecoration(
        // Light blue background for subtle emphasis
        color: fblaBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        // Blue border for definition and branding
        border: Border.all(
          color: fblaBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      // Material wrapper enables ripple effect on tap
      child: Material(
        color: Colors.transparent, // Don't override container background
        child: InkWell(
          borderRadius: BorderRadius.circular(12), // Match container corners
          // Tap handler - currently empty but designed for navigation
          onTap: () {
            // TODO: Navigate to group details page
            // Example: Navigator.push(context, MaterialPageRoute(...))
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Left section: Lynq logo in branded container
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: fblaBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Image(
                      image: AssetImage('assets/Lynq_Logo.png'),
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(width: 16),
                
                // Center section: Group name and join code
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group name
                      Text(
                        group.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: fblaBlue,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Join code row
                      Row(
                        children: [
                          Icon(
                            Icons.key,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Code: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            group.code,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: fblaBlue,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right section: Copy and Leave buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Copy button
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: group.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text('Code copied: ${group.code}'),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.copy,
                        color: fblaGold,
                        size: 22,
                      ),
                      tooltip: 'Copy join code',
                    ),
                    
                    // Leave button
                    IconButton(
                      onPressed: ()=> onRemove(context, group),
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.red[400],
                        size: 22,
                      ),
                      tooltip: 'Leave group',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onRemove(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Leave Group?',
                style: TextStyle(
                  color: fblaBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to leave "${group.name}"?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Delete group from user's groups subcollection
                  await FirebaseFirestore.instance
                      .collection(globals.currentUserRole)
                      .doc(globals.currentUID)
                      .collection('groups')
                      .doc(group.code)
                      .delete();

                  Navigator.pop(dialogContext);

                  // Show success message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text('Left ${group.name}'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.pop(dialogContext);
                  
                  // Show error message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text('Failed to leave group'),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Leave',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
