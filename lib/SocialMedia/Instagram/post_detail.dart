import 'package:flutter/material.dart';

/// Page that displays detailed information about an Instagram post
/// This widget handles various Instagram API response formats and displays
/// post images, captions, likes, and comments in a polished UI
class PostDetailPage extends StatelessWidget {
  // FBLA Official Colors - consistent branding throughout the app
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);
  static const fblaLightGold = Color(0xFFFFF4E0);

  /// The post data object, can be from different API response formats
  /// Supports both node-based and direct property formats
  final dynamic post;

  const PostDetailPage({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    // Extract image URL from various possible JSON structures
    // Different Instagram APIs return data in different formats,
    // so we check multiple possible field names
    String? imageUrl;

    // Check if post data is wrapped in a 'node' object (GraphQL format)
    if (post['node'] != null) {
      imageUrl =
          post['node']['display_url'] ?? // High-res display image
          post['node']['thumbnail_src'] ?? // Medium-res thumbnail
          post['node']['thumbnail_resources']?[2]?['src']; // Array of thumbnails
    } else {
      // Direct property access (REST API format)
      imageUrl =
          post['display_url'] ?? // High-res display image
          post['thumbnail_url'] ?? // Medium-res thumbnail
          post['thumbnail_src'] ?? // Alternative thumbnail field
          post['image_versions2']?['candidates']?[0]?['url'] ?? // Mobile API format
          post['media_url']; // Basic media URL
    }

    // Extract caption text from various possible JSON structures
    // Captions can be nested differently depending on the API version
    String caption = '';
    if (post['node'] != null) {
      // GraphQL format: caption is nested in edges array
      caption =
          post['node']['edge_media_to_caption']?['edges']?[0]?['node']?['text'] ??
          '';
    } else {
      // REST API formats: multiple possible field names
      caption =
          post['caption']?['text'] ?? // Object with text property
          post['edge_media_to_caption']?['edges']?[0]?['node']?['text'] ?? // GraphQL nested
          post['caption_text'] ?? // Direct text field
          '';
    }

    // Extract like and comment counts from various possible JSON structures
    // Initialize with 0 as default in case data is missing
    int likes = 0;
    int comments = 0;

    // Check which format the engagement data is in
    if (post['node'] != null) {
      // GraphQL format: likes and comments are in edge objects
      likes = post['node']['edge_liked_by']?['count'] ?? 0;
      comments = post['node']['edge_media_to_comment']?['count'] ?? 0;
    } else {
      // REST API format: direct count properties
      likes = post['like_count'] ?? post['edge_liked_by']?['count'] ?? 0;
      comments =
          post['comment_count'] ?? post['edge_media_to_comment']?['count'] ?? 0;
    }

    return Scaffold(
      // App bar with gradient background and custom styling
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Post Details',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        // Gradient background for visual appeal
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [fblaNavy, Color(0xFF00528a)],
            ),
          ),
        ),
        elevation: 0, // Flat design, no shadow
      ),
      backgroundColor: Colors.grey.shade50,
      // Scrollable content to handle long captions
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section - displays the post image with loading and error states
            if (imageUrl != null)
              Container(
                // Add shadow for depth
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Loading state - show progress indicator while image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child; // Image loaded
                    return Container(
                      height: 400,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            fblaGold, // Branded loading indicator
                          ),
                          // Show progress if total bytes are known
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null, // Indeterminate if size unknown
                        ),
                      ),
                    );
                  },
                  // Error state - show user-friendly message if image fails to load
                  errorBuilder: (context, error, stackTrace) {
                    // Debug logging to help troubleshoot image loading issues
                    print('Detail image error: $error');
                    print('Tried URL: $imageUrl');
                    return Container(
                      height: 400,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Image failed to load',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              // Fallback when no image URL is available in the post data
              Container(
                height: 400,
                color: Colors.grey.shade200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No image available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Post Info Section - displays engagement stats and caption
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              // Card styling with border and shadow
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row - displays like and comment counts in styled badges
                  Row(
                    children: [
                      // Likes badge with gradient background
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // Instagram-style pink/red gradient
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF3366), Color(0xFFFF6B9D)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$likes',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Comments badge with FBLA gold theme
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: fblaLightGold,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFE7B3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.comment,
                              color: fblaNavy,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$comments',
                              style: const TextStyle(
                                color: fblaNavy,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Caption section - only shown if caption text exists
                  // Uses spread operator to conditionally include widgets
                  if (caption.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    // Caption header
                    const Text(
                      'Caption',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: fblaNavy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Caption text with readable styling
                    Text(
                      caption,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5, // Line height for readability
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
