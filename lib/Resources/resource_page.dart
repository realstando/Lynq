import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/Resources/new_resource.dart';
import 'package:coding_prog/Resources/resource_format.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:coding_prog/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:coding_prog/NavigationBar/custom_actionbutton.dart';

/// A page that displays a list of FBLA resources.
/// Advisors can add and delete resources, while regular users can only view them.
class ResourcePage extends StatefulWidget {
  const ResourcePage({super.key, required this.onNavigate});

  /// Callback function to handle navigation to different pages
  final void Function(int) onNavigate;

  @override
  State<ResourcePage> createState() {
    return _ResourcePageState();
  }
}

class _ResourcePageState extends State<ResourcePage> {
  /// Global key for controlling the scaffold and drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Check if the current user is an advisor (advisors have additional permissions)
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  /// Opens a modal overlay to add a new resource
  /// Only accessible by advisors
  void _openAddResourceOverlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewResource(() {
          // Refresh the page after adding a new resource
          setState(() {});
          Navigator.pop(context);
        }),
      ),
    );
  }

  /// Handles the deletion of a resource with confirmation dialog
  /// @param resource The resource to be deleted
  void _onRemoveResource(Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Dialog header with delete icon and title
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
          // Confirmation message showing the resource title
          content: Text(
            "Are you sure you want to delete '${resource['title']}'? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // Cancel button
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
            // Delete button
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  // Delete the resource from Firestore
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(resource['code'])
                      .collection('resources')
                      .doc(resource['id'])
                      .delete();

                  // Check if widget is still mounted before updating state
                  if (!mounted) return;

                  // Refresh the UI to reflect the deletion
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
      // Navigation drawer
      drawer: DrawerPage(
        icon: Icons.menu_book_rounded,
        name: 'FBLA Resources',
        color: Colors.green[700]!,
        onNavigate: widget.onNavigate,
      ),
      // Custom app bar
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'FBLA Resources',
        color: Colors.green,
        scaffoldKey: _scaffoldKey,
      ),
      // Floating action button to add resources (only visible for advisors)
      floatingActionButton: _isAdvisor
          ? CustomActionButton(
              openAddPage: _openAddResourceOverlay,
              name: "New Resource",
              icon: Icons.folder_open,
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: global.resources!.isEmpty
                // Empty state when no resources exist
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
                // List view displaying all resources
                : ListView.builder(
                    itemCount: global.resources!.length,
                    itemBuilder: (context, index) => ResourceFormat(
                      resource: global.resources![index],
                      onDelete: () =>
                          _onRemoveResource(global.resources![index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
