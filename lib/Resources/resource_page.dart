import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/Resources/new_resource.dart';
import 'package:coding_prog/Resources/resource_format.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/AdminResources/resource_adminformat.dart';
import 'package:coding_prog/Resources/resource.dart';

class ResourcePage extends StatefulWidget {
  const ResourcePage({super.key, required this.onNavigate});
  final void Function(int) onNavigate;

  @override
  State<ResourcePage> createState() {
    return _ResourcePageState();
  }
}

class _ResourcePageState extends State<ResourcePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  void _openAddResourceOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewResource(() {
          setState(() {});
          Navigator.pop(context);
        }),
      ),
    );
  }

  void _onRemoveResource(Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Delete Resource",
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete '${resource['title']}'? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(resource['code'])
                        .collection('resources')
                        .doc(resource['id'])
                        .delete();

                  if (!mounted) return;

                  setState(() {});
                  Navigator.of(context).pop();

                  // Show confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Resource deleted successfully'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.menu_book_rounded,
        name: 'FBLA Resources',
        color: Colors.green[700]!,
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'FBLA Resources',
        color: Colors.blue,
        scaffoldKey: _scaffoldKey,
      ),
      floatingActionButton: _isAdvisor ? Padding(
        padding: EdgeInsets.only(bottom: 20, right: 8),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF003B7E), Color(0xFF002856)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF003B7E).withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openAddResourceOverlay,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Color(0xFFE8B44C), size: 24),
                    SizedBox(width: 12),
                    Text(
                      "New Resource",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ) : null,
      body: Column(
        children: [
          Expanded(
            child: global.resources!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No resources yet",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Tap the + button to add a resource",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: global.resources!.length,
                    itemBuilder: (context, index) => ResourceFormat(
                      resource: global.resources![index],
                      onDelete: () => _onRemoveResource(global.resources![index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
