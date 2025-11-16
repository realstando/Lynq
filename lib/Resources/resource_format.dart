import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceFormat extends StatelessWidget {
  ResourceFormat({required this.resource, required this.onDelete, super.key});

  final Map<String, dynamic> resource;
  final VoidCallback onDelete;
  final bool _isAdvisor = globals.currentUserRole == 'advisors';

  Future<void> _launchURL() async {
    String urlToLaunch = resource['link'];

    if (!urlToLaunch.startsWith('http://') &&
        !urlToLaunch.startsWith('https://') &&
        !urlToLaunch.contains('://')) {
      urlToLaunch = 'https://$urlToLaunch';
    }

    final Uri url = Uri.parse(urlToLaunch);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showLinkDialog(BuildContext context) {
    const primaryBlue = Color(0xFF2563EB);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _launchURL();
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

  void _onRemoveResource(BuildContext context, Map<String, dynamic> resource) {
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
                  // Capture navigator and messenger synchronously to avoid using BuildContext after an await
                  final navigator = Navigator.of(ctx);
                  final messenger = ScaffoldMessenger.of(context);

                  await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(resource['code'])
                        .collection('resources')
                        .doc(resource['id'])
                        .delete();

                  // Close the dialog using the captured navigator
                  navigator.pop();

                  // Show confirmation snackbar using the captured messenger
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
            // Header row
            Row(
              children: [
                const Icon(
                  Icons.auto_stories_rounded,
                  color: primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
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

            // Body text
            Text(
              resource['body'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Link button
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
                      Icon(
                        Icons.language_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'View Resource',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
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
