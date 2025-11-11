import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatelessWidget {
  // FBLA Official Colors
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);
  static const fblaLightGold = Color(0xFFFFF4E0);

  final dynamic post;

  const PostDetailPage({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (post['node'] != null) {
      imageUrl =
          post['node']['display_url'] ??
          post['node']['thumbnail_src'] ??
          post['node']['thumbnail_resources']?[2]?['src'];
    } else {
      imageUrl =
          post['display_url'] ??
          post['thumbnail_url'] ??
          post['thumbnail_src'] ??
          post['image_versions2']?['candidates']?[0]?['url'] ??
          post['media_url'];
    }

    String caption = '';
    if (post['node'] != null) {
      caption =
          post['node']['edge_media_to_caption']?['edges']?[0]?['node']?['text'] ??
          '';
    } else {
      caption =
          post['caption']?['text'] ??
          post['edge_media_to_caption']?['edges']?[0]?['node']?['text'] ??
          post['caption_text'] ??
          '';
    }

    int likes = 0;
    int comments = 0;

    if (post['node'] != null) {
      likes = post['node']['edge_liked_by']?['count'] ?? 0;
      comments = post['node']['edge_media_to_comment']?['count'] ?? 0;
    } else {
      likes = post['like_count'] ?? post['edge_liked_by']?['count'] ?? 0;
      comments =
          post['comment_count'] ?? post['edge_media_to_comment']?['count'] ?? 0;
    }

    return Scaffold(
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [fblaNavy, Color(0xFF00528a)],
            ),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (imageUrl != null)
              Container(
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
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 400,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            fblaGold,
                          ),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
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

            // Post Info Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
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
                  // Stats Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
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

                  // Caption
                  if (caption.isNotEmpty) ...[
                    const SizedBox(height: 20),
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
                    Text(
                      caption,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
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
