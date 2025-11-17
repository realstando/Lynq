import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

/// StatefulWidget for the admin dashboard
/// Allows administrators to review and approve/reject pending advisor registrations
/// Also displays a list of all approved advisors
class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
    required this.onNavigate,
  });

  /// Callback function to handle navigation to different pages
  final void Function(int) onNavigate;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Global key to control the Scaffold state (used for opening drawer)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // FBLA brand colors and status colors
  static const warningOrange = Color(0xFFF4AB19); // Gold for pending status
  static const successGreen = Color(0xFF1D52BC); // Blue for approved status

  @override
  Widget build(BuildContext context) {
    // Firestore references for advisor collections
    final CollectionReference signupRef = FirebaseFirestore.instance.collection(
      'signup_advisors', // Pending advisors awaiting approval
    );
    final CollectionReference approvedRef = FirebaseFirestore.instance
        .collection('advisors'); // Approved advisors

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      // Navigation drawer
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Admin Page',
        color: Colors.black,
        onNavigate: widget.onNavigate,
      ),
      // Custom app bar
      appBar: CustomAppBar(
        color: Colors.black,
        name: "Admin Page",
        scaffoldKey: _scaffoldKey,
        onNavigate: widget.onNavigate,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pending Advisors Section Header
            _buildSectionHeader(
              'Pending Advisors',
              Icons.pending_actions,
              warningOrange,
            ),
            const SizedBox(height: 12),

            // Stream builder for real-time pending advisors list
            StreamBuilder<QuerySnapshot>(
              stream: signupRef.snapshots(),
              builder: (context, snapshot) {
                // Show loading indicator while fetching data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Show empty state if no pending advisors
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    'No pending advisors',
                    Icons.check_circle_outline,
                    successGreen,
                  );
                }

                final advisors = snapshot.data!.docs;

                // Build list of pending advisor cards
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: advisors.length,
                  itemBuilder: (context, index) {
                    final advisor = advisors[index];
                    final fName = advisor['first_name'];
                    final lName = advisor['last_name'];
                    final email = advisor['email'];
                    final password = advisor['password'];

                    return _buildPendingAdvisorCard(
                      fName: fName,
                      lName: lName,
                      email: email,
                      password: password,
                      advisorId: advisor.id,
                      signupRef: signupRef,
                      approvedRef: approvedRef,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            // Approved Advisors Section Header
            _buildSectionHeader(
              'Approved Advisors',
              Icons.verified_user,
              successGreen,
            ),
            const SizedBox(height: 12),

            // Stream builder for real-time approved advisors list
            StreamBuilder<QuerySnapshot>(
              stream: approvedRef.snapshots(),
              builder: (context, snapshot) {
                // Show loading indicator while fetching data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Show empty state if no approved advisors
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    'No approved advisors yet',
                    Icons.group_add,
                    Colors.grey,
                  );
                }

                final approvedAdvisors = snapshot.data!.docs;

                // Build list of approved advisor cards
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: approvedAdvisors.length,
                  itemBuilder: (context, index) {
                    final advisor = approvedAdvisors[index];
                    final fName = advisor['first_name'];
                    final lName = advisor['last_name'];
                    final email = advisor['email'];

                    return _buildApprovedAdvisorCard(
                      fName: fName,
                      lName: lName,
                      email: email,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Builds a section header with icon and title
  /// Used for "Pending Advisors" and "Approved Advisors" sections
  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  /// Builds an empty state widget when no items are present
  /// Shows an icon and message
  Widget _buildEmptyState(String message, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: color.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a card for a pending advisor with approve/reject actions
  ///
  /// When approved:
  /// - Creates Firebase Auth account with provided credentials
  /// - Moves advisor data from 'signup_advisors' to 'advisors' collection
  /// - Sets display name in Firebase Auth
  /// - Deletes from pending collection
  ///
  /// When rejected:
  /// - Shows confirmation dialog
  /// - Deletes from pending collection without creating account
  Widget _buildPendingAdvisorCard({
    required String fName,
    required String lName,
    required String email,
    required String password,
    required String advisorId,
    required CollectionReference signupRef,
    required CollectionReference approvedRef,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: warningOrange.withValues(alpha: 0.08), // Light gold background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: warningOrange.withValues(alpha: 0.3), // Gold border
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Advisor info row with avatar and name/email
              Row(
                children: [
                  // Circular avatar with first initial
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: warningOrange,
                    child: Text(
                      fName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full name
                        Text(
                          '$fName $lName',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email address
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action buttons row
              Row(
                children: [
                  // Approve button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          // Create Firebase Auth account
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          // Set display name
                          await userCredential.user!.updateDisplayName(
                            "$fName $lName",
                          );
                          // Add to approved advisors collection
                          await approvedRef.doc(userCredential.user!.uid).set({
                            'first_name': fName,
                            'last_name': lName,
                            'email': email,
                          });
                          // Remove from pending collection
                          await signupRef.doc(advisorId).delete();

                          // Show success message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Text('Approved $fName $lName'),
                                  ],
                                ),
                                backgroundColor: successGreen,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          // Show error message if account creation fails
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text('Error: ${e.message}'),
                                    ),
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
                        backgroundColor: successGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text(
                        'Approve',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Reject button
                  ElevatedButton(
                    onPressed: () async {
                      // Show confirmation dialog
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text('Reject Advisor?'),
                          content: Text(
                            'Are you sure you want to reject $fName $lName?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      );

                      // If confirmed, delete the pending advisor
                      if (confirm == true) {
                        await signupRef.doc(advisorId).delete();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Advisor rejected'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a card for an approved advisor (read-only display)
  /// Shows advisor info with a checkmark indicator
  Widget _buildApprovedAdvisorCard({
    required String fName,
    required String lName,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: successGreen.withValues(alpha: 0.08), // Light blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: successGreen.withValues(alpha: 0.3), // Blue border
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Circular avatar with first initial
              CircleAvatar(
                radius: 24,
                backgroundColor: successGreen,
                child: Text(
                  fName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full name
                    Text(
                      '$fName $lName',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email address
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Checkmark icon indicating approved status
              Icon(
                Icons.check_circle,
                color: successGreen,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
