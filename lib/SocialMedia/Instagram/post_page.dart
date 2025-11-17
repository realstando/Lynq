import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:coding_prog/SocialMedia/Instagram/post_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A StatefulWidget that displays Instagram posts for a given username
/// Uses the Simple Instagram API from RapidAPI to fetch and display posts
class PostsPage extends StatefulWidget {
  // FBLA Official Brand Colors
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);

  /// The Instagram username to fetch posts for
  final String username;

  PostsPage({required this.username});

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  /// List to store fetched Instagram posts
  List<dynamic> posts = [];

  /// Flag to track loading state
  bool isLoading = true;

  /// Stores error messages if API request fails
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Fetch posts when the widget is first created
    fetchPosts();
  }

  /// Fetches Instagram posts from the RapidAPI endpoint
  /// Makes an HTTP GET request and updates the UI based on response
  Future<void> fetchPosts() async {
    // Reset state before fetching
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // RapidAPI key for Simple Instagram API
      final String insta_apiKey = dotenv.env['insta_apiKey']!;

      // Make GET request to fetch account info including posts
      final response = await http.get(
        Uri.parse(
          'https://simple-instagram-api.p.rapidapi.com/account-info?username=${widget.username}',
        ),
        headers: {
          'x-rapidapi-host': 'simple-instagram-api.p.rapidapi.com',
          'x-rapidapi-key': insta_apiKey,
        },
      );

      // Debug logging
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Check if request was successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed Data: $data');

        // Update state with fetched posts
        // Try multiple possible JSON keys as API response format may vary
        setState(() {
          posts =
              data['edge_owner_to_timeline_media']?['edges'] ??
              data['posts'] ??
              data['items'] ??
              [];
          isLoading = false;
        });
      } else {
        // Handle non-200 status codes
        setState(() {
          errorMessage =
              'Failed to load posts.\nStatus: ${response.statusCode}\nResponse: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any exceptions (network errors, parsing errors, etc.)
      print('Exception: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  /// Opens the Instagram profile in an external browser or Instagram app
  /// Attempts external app first, then falls back to platform default
  void _openInstagram() async {
    final url = Uri.parse('https://instagram.com/${widget.username}');
    try {
      // Try to open in Instagram app or external browser
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // If external app fails, try with platform default (in-app browser)
      try {
        await launchUrl(
          url,
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        print('Error launching URL: $e');
        // Show error snackbar to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not open Instagram. Please check if Instagram is installed.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with gradient background and Instagram username
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '@${widget.username}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        // Gradient background using FBLA colors
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PostsPage.fblaNavy, Color(0xFF00528a)],
            ),
          ),
        ),
        elevation: 0,
        actions: [
          // Button to open Instagram profile externally
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: _openInstagram,
            tooltip: 'Open in Instagram',
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      body: isLoading
          // Show loading spinner while fetching posts
          ? Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  PostsPage.fblaGold,
                ),
              ),
            )
          // Show error message if fetch failed
          : errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error icon container
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Error title
                    Text(
                      'Failed to Load Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Error message details
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Retry button with gradient styling
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [PostsPage.fblaGold, Color(0xFFFFD666)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: PostsPage.fblaGold.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: PostsPage.fblaNavy,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        onPressed: fetchPosts,
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          // Show empty state if no posts found
          : posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Empty state icon container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFE7B3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      size: 40,
                      color: PostsPage.fblaNavy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No posts found',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          // Display posts in a grid layout with pull-to-refresh
          : RefreshIndicator(
              color: PostsPage.fblaGold,
              onRefresh: fetchPosts,
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                // 3-column grid layout
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  // Extract image URL from various possible JSON structures
                  String? imageUrl;

                  // Try Instagram's standard edge format
                  if (post['node'] != null) {
                    imageUrl =
                        post['node']['thumbnail_src'] ??
                        post['node']['display_url'] ??
                        post['node']['thumbnail_resources']?[0]?['src'];
                  } else {
                    // Try alternative formats
                    imageUrl =
                        post['thumbnail_url'] ??
                        post['display_url'] ??
                        post['thumbnail_src'] ??
                        post['image_versions2']?['candidates']?[0]?['url'] ??
                        post['media_url'];
                  }

                  // Debug logging if image URL not found
                  if (imageUrl == null) {
                    print('Post $index structure: ${post.keys}');
                  }

                  // Grid item with tap navigation to detail page
                  return GestureDetector(
                    onTap: () {
                      // Navigate to detailed post view
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // Display image if URL exists, otherwise show placeholder
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                // Show loading indicator while image loads
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(
                                                  PostsPage.fblaGold,
                                                ),
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                // Show error icon if image fails to load
                                errorBuilder: (context, error, stackTrace) {
                                  print('Image load error: $error');
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.broken_image,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Error',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            // Show placeholder if no image URL found
                            : Container(
                                color: Colors.grey.shade300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'No image',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
