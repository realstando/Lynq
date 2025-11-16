import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget that displays a group card with branding and interactive elements
/// Shows group name, join code, and provides copy functionality
/// Designed with FBLA branding colors and modern Material Design principles
class GroupFormat extends StatelessWidget {
  /// The group data containing 'name' and 'code' fields
  /// Expected structure: {'name': String, 'code': String}
  final Map<String, dynamic> group;

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
            // Horizontal layout: [Logo] [Group Info] [Copy Button]
            child: Row(
              children: [
                // Left section: Lynq logo in branded container
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: fblaBlue, // Solid blue background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0), // Inner padding for logo
                    child: Image(
                      image: AssetImage('assets/Lynq_Logo.png'),
                      fit: BoxFit
                          .contain, // Scale logo to fit without distortion
                      color: Colors.white, // Tint logo white for contrast
                    ),
                  ),
                ),

                SizedBox(width: 16), // Space between logo and text
                // Center section: Group name and join code
                Expanded(
                  // Expanded allows this section to take remaining horizontal space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group name - primary text
                      Text(
                        group['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: fblaBlue,
                        ),
                      ),
                      SizedBox(height: 4), // Space between name and code
                      // Join code row with icon and label
                      Row(
                        children: [
                          // Key icon to indicate this is an access code
                          Icon(
                            Icons.key,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          // "Code:" label
                          Text(
                            'Code: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          // Actual join code - emphasized styling
                          Text(
                            group['code'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: fblaBlue,
                              letterSpacing:
                                  1.5, // Wide spacing for readability
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right section: Copy button for quick code sharing
                IconButton(
                  onPressed: () {
                    // Copy join code to clipboard
                    Clipboard.setData(ClipboardData(text: group['code']));

                    // Show confirmation snackbar with success styling
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        // Success message with checkmark icon
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text('Code copied: ${group['code']}'),
                          ],
                        ),
                        backgroundColor: Colors.green, // Green for success
                        behavior: SnackBarBehavior.floating, // Floating style
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(seconds: 2), // Auto-dismiss after 2s
                      ),
                    );
                  },
                  // Copy icon in FBLA gold for visibility and branding
                  icon: Icon(
                    Icons.copy,
                    color: fblaGold,
                    size: 22,
                  ),
                  tooltip: 'Copy join code', // Accessibility label
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
