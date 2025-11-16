import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/Groups/new_group.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/Groups/group_format.dart';
import 'package:coding_prog/NavigationBar/custom_actionbutton.dart';

class GroupPage extends StatefulWidget {
  final Function(int) onNavigate;
  const GroupPage({
    super.key,
    required this.onNavigate,
  });
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _joinCodeController = TextEditingController();
  final bool _isAdvisor = globals.currentUserRole == 'advisors';
  String? _errorMessage;

  // FBLA Colors
  static const Color fblaBlue = Color(0xFF1D52BC);
  static const Color fblaDarkBlue = Color(0XFF0A2E7F);
  static const Color fblaGold = Color(0xFFF4AB19);

  void _addGroup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewGroup(
          () {
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  void showJoinDialog() {
    _joinCodeController.clear();
    _errorMessage = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: [
                  // Logo instead of icon
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: fblaBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Image(
                        image: AssetImage('assets/Lynq_Logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Join Group',
                    style: TextStyle(
                      color: fblaDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter the 6-character join code provided by your teacher',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _joinCodeController,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ABC123',
                      prefixIcon: Icon(Icons.key, color: fblaBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: fblaBlue, width: 2),
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      errorText: _errorMessage,
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (_errorMessage != null) {
                        setDialogState(() {
                          _errorMessage = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String code = _joinCodeController.text.trim().toUpperCase();
                    final groupDoc = await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(code)
                        .get();
                    final studentDoc = await FirebaseFirestore.instance
                        .collection('students')
                        .doc(globals.currentUID)
                        .collection('groups')
                        .doc(code)
                        .get();

                    if (code.isEmpty) {
                      setDialogState(() {
                        _errorMessage = 'Please enter a join code';
                      });
                      return;
                    }

                    if (code.length != 6) {
                      setDialogState(() {
                        _errorMessage = 'Code must be 6 characters';
                      });
                      return;
                    }

                    if (!groupDoc.exists) {
                      setDialogState(() {
                        _errorMessage = 'Not a valid join code';
                      });
                      return;
                    }

                    if (studentDoc.exists) {
                      setDialogState(() {
                        _errorMessage = 'Already joined this group';
                      });
                      return;
                    } else {
                      await FirebaseFirestore.instance
                          .collection('students')
                          .doc(globals.currentUID)
                          .collection('groups')
                          .doc(code)
                          .set({});
                    }

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Found group with code: $code'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fblaBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Join',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isAdvisor
          ? CustomActionButton(
              openAddPage: _addGroup,
              name: "New Group",
              icon: Icons.people_outlined,
            )
          : null,
      backgroundColor: Colors.grey[50],
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerPage(
          icon: Icons.group_rounded,
          name: "Groups",
          color: fblaBlue,
          onNavigate: widget.onNavigate,
        ),
      ),
      appBar: CustomAppBar(
        name: "Groups",
        color: fblaBlue,
        scaffoldKey: _scaffoldKey,
        onNavigate: widget.onNavigate,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Join Group Card with Logo
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: fblaBlue.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Logo instead of key icon
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: fblaGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Image(
                                image: AssetImage('assets/Lynq_Logo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Join a Group',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: fblaDarkBlue,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Enter a 6-character join code to connect with your FBLA chapters',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: showJoinDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fblaBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.group_add, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'Enter Join Code',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Your Groups Section Header with Logo
                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: fblaBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Image(
                            image: AssetImage('assets/Lynq_Logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Your Groups',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: fblaDarkBlue,
                        ),
                      ),
                      if (_isAdvisor) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: fblaGold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: fblaDarkBlue,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 16),

                  // Groups List
                  global.groups!.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Logo in empty state
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: fblaBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Image(
                                    image: AssetImage('assets/Lynq_Logo.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No groups yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _isAdvisor
                                    ? 'Create your first group to get started'
                                    : 'Enter a join code above to join your first group',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: global.groups!.map((group) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: GroupFormat(group),
                            );
                          }).toList(),
                        ),

                  SizedBox(height: 32),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.school,
                          title: _isAdvisor ? 'Chapter' : 'Your Chapter',
                          description: _isAdvisor
                              ? 'Manage school groups'
                              : 'Join your school\'s FBLA chapter',
                          color: fblaBlue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: _isAdvisor ? 'State' : 'State Level',
                          description: _isAdvisor
                              ? 'State-level groups'
                              : 'Connect with state chapters',
                          color: fblaDarkBlue,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Benefits Section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: fblaGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: fblaGold.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isAdvisor
                                  ? Icons.admin_panel_settings
                                  : Icons.star,
                              color: fblaGold,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              _isAdvisor
                                  ? 'Advisor Features'
                                  : 'Why join groups?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: fblaDarkBlue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        if (_isAdvisor) ...[
                          _buildBenefitItem('Create and manage groups'),
                          _buildBenefitItem('Generate join codes'),
                          _buildBenefitItem('Track member participation'),
                          _buildBenefitItem('Monitor competition progress'),
                        ] else ...[
                          _buildBenefitItem('Track your competition progress'),
                          _buildBenefitItem('Connect with chapter members'),
                          _buildBenefitItem('Access exclusive resources'),
                          _buildBenefitItem('Stay updated on events'),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: fblaDarkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: fblaGold, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }
}
