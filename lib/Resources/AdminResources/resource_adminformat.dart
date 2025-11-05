import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminResourceFormat extends StatelessWidget {
  const AdminResourceFormat({
    required this.resource,
    required this.onDelete,
    super.key,
  });

  final Resource resource;
  final VoidCallback onDelete;

  Future<void> _launchURL() async {
    String urlToLaunch = resource.link;

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
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF003B7E), Color(0xFF002856)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: Color(0xFFE8B44C),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Open Resource",
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: Color(0xFF003B7E),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        resource.link,
                        style: TextStyle(
                          color: Color(0xFF003B7E),
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
              SizedBox(height: 12),
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
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003B7E), Color(0xFF002856)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _launchURL();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Row(
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF5FFBAE),
            Color(0xFF8FFF9E),
            Color(0xFFB0FFD1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4DD9A5).withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 15,
            offset: Offset(-5, -5),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header section with delete button
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A2E7F),
                    Color(0xFF1345B6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // Icon with gradient background
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.shade400,
                          Colors.amber.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 15),
                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resource.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              height: 2,
                              width: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber,
                                    Colors.orange,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[300],
                      size: 26,
                    ),
                    tooltip: 'Delete Resource',
                  ),
                ],
              ),
            ),

            // Body content
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Body text
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      resource.body,
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 25),

                  // View Resource button
                  Center(
                    child: GestureDetector(
                      onTap: () => _showLinkDialog(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0A2E7F),
                              Color(0xFF1345B6),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF0A2E7F).withOpacity(0.5),
                              blurRadius: 15,
                              offset: Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 8,
                              offset: Offset(-2, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'View Resource',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
