import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/Groups/group.dart';
import 'package:coding_prog/Groups/new_group.dart';
import 'package:coding_prog/Groups/group_format.dart';

class AdminGroupPage extends StatefulWidget {
  final Function(int) onNavigate;
  const AdminGroupPage({
    super.key,
    required this.onNavigate,
  });
  @override
  State<AdminGroupPage> createState() => _AdminGroupPageState();
}

class _AdminGroupPageState extends State<AdminGroupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _joinCodeController = TextEditingController();
  String _joinCode = "";
  String? _errorMessage;

  // FBLA Colors
  static const Color fblaBlue = Color.fromARGB(255, 1, 26, 167);
  static const Color fblaDarkBlue = Color(0xFF1D52BC);
  static const Color fblaGold = Color(0xFFF4AB19);

  void _addGroup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewGroup(
          addGroup: (Group group) {
            setState(() {
              groups.add(group);
            });
          },
        ),
      ),
    );
  }

  final List<Group> groups = [
    Group(name: "Washington FBLA"),
    Group(name: "North Creek FBLA"),
  ];

  // Joined groups (groups admin has joined with code)
  List<Group> joinedGroups = [];

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
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: fblaBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.group_add, color: fblaBlue, size: 28),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Join Group',
                    style: TextStyle(
                      color: fblaDarkBlue,
                      fontWeight: FontWeight.bold,
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
                  onPressed: () {
                    String code = _joinCodeController.text.trim().toUpperCase();

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

                    setState(() {
                      _joinCode = code;
                      // TODO: Search for group and add to joinedGroups if found
                    });
                    print('Join code: $code');
                    Navigator.of(context).pop();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Searching for group with code: $code'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addGroup,
        backgroundColor: fblaBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "New Group",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        elevation: 6,
      ),
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
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [fblaBlue, fblaDarkBlue],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Icon(
                    Icons.groups,
                    size: 80,
                    color: fblaGold,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'FBLA Groups',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Manage your chapters and connect with members',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Join Group Card
                  Container(
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
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: fblaGold.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.key,
                              size: 40,
                              color: fblaGold,
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
                            'Enter a 6-character join code to connect with other FBLA chapters',
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
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
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

                  // Your Groups Section Header
                  Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: fblaBlue,
                        size: 28,
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
                  ),
                  SizedBox(height: 16),

                  // Groups List
                  groups.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(40),
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
                            children: [
                              Icon(
                                Icons.group_outlined,
                                size: 60,
                                color: Colors.grey[400],
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
                                'Create your first group to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: groups.map((group) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: GroupFormat(group),
                            );
                          }).toList(),
                        ),

                  // Joined Groups Section (if any)
                  if (joinedGroups.isNotEmpty) ...[
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Icon(Icons.folder_special, color: fblaBlue, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Joined Groups',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: fblaDarkBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: joinedGroups.map((group) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: GroupFormat(group),
                        );
                      }).toList(),
                    ),
                  ],

                  SizedBox(height: 32),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.school,
                          title: 'Chapter',
                          description: 'Manage school groups',
                          color: fblaBlue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'State',
                          description: 'State-level groups',
                          color: fblaDarkBlue,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Admin Benefits Section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: fblaGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: fblaGold.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              color: fblaGold,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Admin Features',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: fblaDarkBlue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildBenefitItem('Create and manage groups'),
                        _buildBenefitItem('Generate join codes'),
                        _buildBenefitItem('Join other groups as a member'),
                        _buildBenefitItem('Track member participation'),
                        _buildBenefitItem('Monitor competition progress'),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
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
