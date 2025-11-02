import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceFormat extends StatelessWidget {
  const ResourceFormat({required this.resource, super.key});

  final Resource resource;

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(resource.link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
            // Header section with glass morphism effect
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
                  // Star badge
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Body content with sophisticated styling
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Body text with better typography
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

                  // Sophisticated hyperlink button
                  Center(
                    child: GestureDetector(
                      onTap: _launchURL,
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
