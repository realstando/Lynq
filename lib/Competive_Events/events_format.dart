import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsFormat extends StatefulWidget {
  final CompetitiveEvent event;

  const EventsFormat({super.key, required this.event});

  @override
  State<EventsFormat> createState() => _EventsFormatState();
}

class _EventsFormatState extends State<EventsFormat> {
  // Simplified FBLA colors
  static const fblaNavy = Color(0xFF0B1F3F);
  static const fblaBlue = Color(0xFF4A7BC8);
  static const fblaGold = Color(0xFFD4921F);

  bool _isStarred = false; // Track starred state

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  void _openLink() async {
    final Uri url = Uri.parse(widget.event.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch ${widget.event.link}");
    }
  }

  void _toggleStar() async {
    setState(() {
      _isStarred = !_isStarred;
    });

    await _toggleFavoriteInFirestore();

    // Optional: Show feedback
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
            Text(_isStarred ? 'Added to your competitive events' : 'Removed from competitive events'),
          ],
        ),
        backgroundColor: _isStarred ? fblaGold : Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _toggleFavoriteInFirestore() async {

    final docRef = FirebaseFirestore.instance
        .collection('students')
        .doc(globals.currentUID)
        .collection('events')
        .doc(widget.event.title);  // event title is the doc ID

    if (_isStarred) {
      // Add an EMPTY document
      await docRef.set({});
    } else {
      // Remove the document
      await docRef.delete();
    }
  }

  Future<void> _loadFavoriteState() async {

    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(globals.currentUID)
        .collection('events')
        .doc(widget.event.title)
        .get();

    if (doc.exists) {
      setState(() {
        _isStarred = true;
      });
    }
  }

  Color _getCategoryColor() {
    switch (widget.event.category) {
      case EventCategory.objective:
        return fblaNavy;
      case EventCategory.presentation:
        return fblaBlue;
      case EventCategory.roleplay:
        return fblaGold;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.event.category) {
      case EventCategory.objective:
        return Icons.quiz_outlined;
      case EventCategory.presentation:
        return Icons.present_to_all_outlined;
      case EventCategory.roleplay:
        return Icons.theater_comedy_outlined;
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _openLink,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(),
                      size: 18,
                      color: categoryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.event.category.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    // Star button
                    IconButton(
                      icon: AnimatedSwitcher(
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
                          size: 24,
                        ),
                      ),
                      onPressed: _toggleStar,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.open_in_new,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ],
                ),

                // const SizedBox(height: 12),

                // Event Title
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fblaNavy,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  widget.event.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}