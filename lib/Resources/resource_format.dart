import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A StatelessWidget that displays a resource card with title, body, and link
/// Advisors have additional permission to delete resources
class ResourceFormat extends StatelessWidget {
  ResourceFormat({required this.resource, required this.onDelete, super.key});

  /// Map containing resource data (title, body, link, code, id)
  final Map<String, dynamic> resource;

  /// Callback function triggered when resource is deleted
  final VoidCallback onDelete;

  /// Flag to check if current user is an advisor (has delete permissions)
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  /// Launches the resource URL in an external browser
  /// Automatically adds https:// protocol if missing
  Future<void> _launchURL() async {
    String urlToLaunch = resource['link'];

    // Add https:// protocol if URL doesn't have any protocol
    if (!urlToLaunch.startsWith('http://') &&
        !urlToLaunch.startsWith('https://') &&
        !urlToLaunch.contains('://')) {
      urlToLaunch = 'https://$urlToLaunch';
    }

    final Uri url = Uri.parse(urlToLaunch);

    // Attempt to launch URL in external browser
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Shows a confirmation dialog before opening the resource link
  /// Displays the URL and provides cancel/open options
  void _showLinkDialog(BuildContext context) {
    const primaryBlue = Color(0xFF2563EB);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Dialog header with globe icon
          title: const Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: primaryBlue,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                "Open Resource",
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Dialog content showing URL preview
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You're about to open:",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              // Container displaying the URL with styling
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryBlue.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, color: primaryBlue, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        resource['link'],
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Info text about browser opening
              Text(
                "This will open in your browser.",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          // Action buttons: Cancel and Open Link
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            // Open Link button
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                _launchURL(); // Launch URL
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Open Link",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.open_in_new, size: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog before deleting a resource
  /// Only accessible to advisors
  /// Deletes from Firestore and shows success snackbar
  void _onRemoveResource(BuildContext context, Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Dialog header with delete icon
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
          // Confirmation message with resource title
          content: Text(
            "Are you sure you want to delete '${resource['title']}'? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          // Action buttons: Cancel and Delete
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
            // Delete button with red styling
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  // Capture navigator and messenger synchronously
                  // This avoids BuildContext usage after async operations
                  final navigator = Navigator.of(ctx);
                  final messenger = ScaffoldMessenger.of(context);

                  // Delete resource from Firestore
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(resource['code']) // Group code
                      .collection('resources')
                      .doc(resource['id']) // Resource document ID
                      .delete();

                  // Close the dialog
                  navigator.pop();

                  // Show success confirmation snackbar
                  messenger.showSnackBar(
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
  Widget build(context) {
    const Color primaryBlue = Color(0xFF2563EB);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Card styling with blue border and background
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and optional delete button
            Row(
              children: [
                // Book icon
                const Icon(
                  Icons.auto_stories_rounded,
                  color: primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                // Resource title
                Expanded(
                  child: Text(
                    resource['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Delete button (only visible to advisors)
                if (_isAdvisor)
                  IconButton(
                    onPressed: () => _onRemoveResource(context, resource),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[300],
                      size: 26,
                    ),
                    tooltip: 'Delete Resource',
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Resource description/body text
            Text(
              resource['body'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4, // Line height for better readability
              ),
            ),

            const SizedBox(height: 16),

            // "View Resource" button centered at bottom
            Center(
              child: GestureDetector(
                onTap: () => _showLinkDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Globe icon
                      Icon(
                        Icons.language_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      // Button text
                      Text(
                        'View Resource',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      // Forward arrow icon
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
