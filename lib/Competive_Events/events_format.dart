import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:url_launcher/url_launcher.dart';

/// A card widget that displays FBLA competitive event information
/// Features category-based theming, favoriting functionality, and external link opening
/// Integrates with Firestore to persist user's favorite events
class EventsFormat extends StatefulWidget {
  /// The competitive event data to display
  /// Contains title, description, link, and category information
  final CompetitiveEvent event;

  const EventsFormat({super.key, required this.event});

  @override
  State<EventsFormat> createState() => _EventsFormatState();
}

class _EventsFormatState extends State<EventsFormat> {
  final bool _isAdvisor = globals.currentUserRole == 'advisors';
  // FBLA Official Brand Colors for consistent theming
  static const fblaNavy = Color(0xFF0B1F3F);
  static const fblaBlue = Color(0xFF4A7BC8);
  static const fblaGold = Color(0xFFD4921F);

  /// Tracks whether this event is starred/favorited by the user
  /// Synced with Firestore for persistence across sessions
  bool _isStarred = false;

  /// Load the favorite state from Firestore when widget initializes
  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  /// Shows a confirmation dialog before opening the event link
  /// Displays event details and warns user they're leaving the app
  /// Uses category-based color theming for visual consistency
  void _showLinkDialog(BuildContext context) {
    final categoryColor = _getCategoryColor();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Dialog title with icon
          title: Row(
            children: [
              Icon(
                Icons.open_in_new,
                color: categoryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Open Event",
                  style: TextStyle(
                    color: fblaNavy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Dialog content showing event details
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction text
              Text(
                "You're about to open:",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              // Event info card with category-themed styling
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event title
                    Text(
                      widget.event.title,
                      style: TextStyle(
                        color: fblaNavy,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Event link with icon
                    Row(
                      children: [
                        Icon(Icons.link, color: categoryColor, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.event.link,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Warning message about external browser
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
          // Action buttons
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
            // Open link button with category color
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog first
                _launchURL(); // Then open link
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: categoryColor,
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

  /// Opens the event link in the device's default browser
  /// Automatically adds https:// protocol if missing
  /// Throws exception if URL cannot be opened
  Future<void> _launchURL() async {
    String urlToLaunch = widget.event.link;

    // Ensure URL has a valid protocol
    // Many users forget to include https://, so we add it automatically
    if (!urlToLaunch.startsWith('http://') &&
        !urlToLaunch.startsWith('https://') &&
        !urlToLaunch.contains('://')) {
      urlToLaunch = 'https://$urlToLaunch';
    }

    final Uri url = Uri.parse(urlToLaunch);
    // Launch in external browser app (not in-app webview)
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Toggles the star/favorite state and syncs with Firestore
  /// Shows a snackbar to confirm the action to the user
  void _toggleStar() async {
    // Update UI immediately for responsive feel
    setState(() {
      _isStarred = !_isStarred;
    });

    // Sync with Firestore in the background
    await _toggleFavoriteInFirestore();

    // Show confirmation feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isStarred ? Icons.star : Icons.star_border,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _isStarred
                  ? 'Added to your competitive events'
                  : 'Removed from competitive events',
            ),
          ],
        ),
        // Gold for added, gray for removed
        backgroundColor: _isStarred ? fblaGold : Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Syncs favorite state with Firestore
  /// Creates or deletes a document in the user's events subcollection
  /// Document existence indicates the event is favorited (no data needed)
  Future<void> _toggleFavoriteInFirestore() async {
    // Path: students/{userId}/events/{eventTitle}
    final docRef = FirebaseFirestore.instance
        .collection('students')
        .doc(globals.currentUID) // Global variable holding current user ID
        .collection('events')
        .doc(widget.event.title); // Event title is used as document ID

    if (_isStarred) {
      // Add event to favorites by creating an empty document
      // Document existence = favorited, no data storage needed
      await docRef.set({});
    } else {
      // Remove from favorites by deleting the document
      await docRef.delete();
    }
  }

  /// Loads the favorite state from Firestore when widget initializes
  /// Checks if a document exists for this event in user's favorites
  Future<void> _loadFavoriteState() async {
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(globals.currentUID)
        .collection('events')
        .doc(widget.event.title)
        .get();

    // If document exists, this event is favorited
    if (doc.exists) {
      setState(() {
        _isStarred = true;
      });
    }
    // If document doesn't exist, _isStarred remains false (default)
  }

  /// Returns the theme color based on event category
  /// Used for consistent color coding throughout the UI
  Color _getCategoryColor() {
    switch (widget.event.category) {
      case EventCategory.objective:
        return fblaNavy; // Navy for objective/test events
      case EventCategory.presentation:
        return fblaBlue; // Blue for presentation events
      case EventCategory.roleplay:
        return fblaGold; // Gold for roleplay events
    }
  }

  /// Returns the appropriate icon based on event category
  /// Provides visual distinction between event types
  IconData _getCategoryIcon() {
    switch (widget.event.category) {
      case EventCategory.objective:
        return Icons.quiz_outlined; // Quiz icon for objective tests
      case EventCategory.presentation:
        return Icons.present_to_all_outlined; // Presentation icon
      case EventCategory.roleplay:
        return Icons.theater_comedy_outlined; // Theater icon for roleplay
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      // Material wrapper for ripple effect on tap
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          // Tapping the card opens the link dialog
          onTap: () => _showLinkDialog(context),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16, 
              16, 
              16, 
              16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with category badge and action buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Category icon
                    Icon(
                      _getCategoryIcon(),
                      size: 18,
                      color: categoryColor,
                    ),
                    const SizedBox(width: 8),
                    // Category label in uppercase
                    Text(
                      widget.event.category.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                        letterSpacing: 0.5, // Wide spacing for emphasis
                      ),
                    ),
                    const Spacer(), // Push buttons to the right
                    if (!_isAdvisor) ...[
                      SizedBox(
                        height: 18, // Same as category icon height
                        child: GestureDetector(
                          onTap: _toggleStar,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                _isStarred ? Icons.star : Icons.star_border,
                                key: ValueKey(_isStarred),
                                color: _isStarred ? fblaGold : Colors.grey[600],
                                size: 18, // ✅ Match category icon size
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // External link indicator icon
                    Icon(
                      Icons.open_in_new,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                // Event title - main identifier
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fblaNavy,
                  ),
                ),

                const SizedBox(height: 8),

                // Event description with ellipsis for long text
                Text(
                  widget.event.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4, // Line height for readability
                  ),
                  maxLines: 3, // Limit to 3 lines
                  overflow:
                      TextOverflow.ellipsis, // Show ... if text is cut off
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
