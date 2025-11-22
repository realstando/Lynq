import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

/// StatefulWidget for the admin dashboard
/// Allows administrators to review and approve/reject pending advisor registrations
/// Also displays lists of all approved advisors, students, and groups
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
  static const studentPurple = Color(0xFF8B5CF6); // Purple for students
  static const groupTeal = Color(0xFF14B8A6); // Teal for groups

  String _selectedView = "Advisors";

  final List<String> _viewOptions = [
    "Advisors",
    "Students",
    "Groups",
  ];

  @override
  Widget build(BuildContext context) {
    // Firestore references for collections
    final CollectionReference signupRef = FirebaseFirestore.instance.collection(
      'signup_advisors', // Pending advisors awaiting approval
    );
    final CollectionReference approvedRef = FirebaseFirestore.instance
        .collection('advisors'); // Approved advisors
    final CollectionReference studentsRef = FirebaseFirestore.instance
        .collection('students'); // All students
    final CollectionReference groupsRef = FirebaseFirestore.instance
        .collection('groups'); // All groups

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
        name: "Admin Dashboard",
        scaffoldKey: _scaffoldKey,
        onNavigate: widget.onNavigate,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Container(
                width: double.infinity, // Full width
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true, // Forces dropdown to use full width
                    value: _selectedView,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    items: _viewOptions.map((view) {
                      return DropdownMenuItem(
                        value: view,
                        child: Text(view),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedView = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedView == "Advisors") ...[
              // Pending Advisors Section
              _buildSectionHeader(
                'Pending Advisors',
                Icons.pending_actions,
                warningOrange,
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: signupRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(
                      'No pending advisors',
                      Icons.check_circle_outline,
                      successGreen,
                    );
                  }

                  final advisors = snapshot.data!.docs;

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

              // Approved Advisors Section
              _buildSectionHeader(
                'Approved Advisors',
                Icons.verified_user,
                successGreen,
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: approvedRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(
                      'No approved advisors yet',
                      Icons.group_add,
                      Colors.grey,
                    );
                  }

                  final approvedAdvisors = snapshot.data!.docs;

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

              const SizedBox(height: 32),
            ],

            if (_selectedView == "Students") ...[
              // Students Section
              _buildSectionHeader(
                'All Students',
                Icons.school,
                studentPurple,
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: studentsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(
                      'No students registered yet',
                      Icons.person_add,
                      Colors.grey,
                    );
                  }

                  final students = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final fName = student['first_name'] ?? 'N/A';
                      final lName = student['last_name'] ?? 'N/A';
                      final email = student['email'] ?? 'N/A';

                      return _buildStudentCard(
                        fName: fName,
                        lName: lName,
                        email: email,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 32),
            ],

            if (_selectedView == "Groups") ...[
              // Groups Section
              _buildSectionHeader(
                'All Groups',
                Icons.groups,
                groupTeal,
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: groupsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(
                      'No groups created yet',
                      Icons.group_add,
                      Colors.grey,
                    );
                  }

                  final groups = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final name = group['name'] ?? 'Unnamed Group';
                      final code = group.id;

                      return _buildGroupCard(
                        name: name,
                        code: code,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a section header with icon and title
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
            Icon(icon, size: 48, color: color.withOpacity(0.5)),
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
        color: warningOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: warningOrange.withOpacity(0.3),
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
              Row(
                children: [
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
                        Text(
                          '$fName $lName',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          await userCredential.user!.updateDisplayName(
                            "$fName $lName",
                          );
                          await approvedRef.doc(userCredential.user!.uid).set({
                            'first_name': fName,
                            'last_name': lName,
                            'email': email,
                          });
                          await signupRef.doc(advisorId).delete();

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
                  ElevatedButton(
                    onPressed: () async {
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
  Widget _buildApprovedAdvisorCard({
    required String fName,
    required String lName,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: successGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: successGreen.withOpacity(0.3),
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
                    Text(
                      '$fName $lName',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
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

  /// Builds a card for a student (read-only display)
  Widget _buildStudentCard({
    required String fName,
    required String lName,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: studentPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: studentPurple.withOpacity(0.3),
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
              CircleAvatar(
                radius: 24,
                backgroundColor: studentPurple,
                child: Text(
                  fName.isNotEmpty ? fName[0].toUpperCase() : '?',
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
                    Text(
                      '$fName $lName',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
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
              Icon(
                Icons.school,
                color: studentPurple,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a card for a group (read-only display)
  Widget _buildGroupCard({
    required String name,
    required String code,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: groupTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: groupTeal.withOpacity(0.3),
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
              CircleAvatar(
                radius: 24,
                backgroundColor: groupTeal,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.key, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Code: ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: groupTeal,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.groups,
                color: groupTeal,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}