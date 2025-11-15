import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsFormat extends StatelessWidget {
  final CompetitiveEvent event;

  const EventsFormat({super.key, required this.event});

  // Simplified FBLA colors
  static const fblaNavy = Color(0xFF0B1F3F);
  static const fblaBlue = Color(0xFF4A7BC8);
  static const fblaGold = Color(0xFFD4921F);

  void _openLink() async {
    final Uri url = Uri.parse(event.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch ${event.link}");
    }
  }

  Color _getCategoryColor() {
    switch (event.category) {
      case EventCategory.objective:
        return fblaNavy;
      case EventCategory.presentation:
        return fblaBlue;
      case EventCategory.roleplay:
        return fblaGold;
    }
  }

  IconData _getCategoryIcon() {
    switch (event.category) {
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
            padding: const EdgeInsets.all(16),
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
                      event.category.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.open_in_new,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Event Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fblaNavy,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  event.description,
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
