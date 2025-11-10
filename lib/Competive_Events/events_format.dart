import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsFormat extends StatelessWidget {
  final CompetitiveEvent event;

  const EventsFormat({super.key, required this.event});

  // Enhanced FBLA-inspired color palette with better visibility
  static const fblaNavyDark = Color(0xFF0B1F3F);
  static const fblaNavyMid = Color(0xFF1A3A6B);
  static const fblaNavyLight = Color(0xFF2E5B9E);
  static const fblaBrightBlue = Color(0xFF4A7BC8);
  static const fblaSkyBlue = Color(0xFF6B9FE8);

  static const fblaGold = Color(0xFFD4921F); // Rich orange-gold
  static const fblaLightGold = Color(0xFFE8AD3F); // Warmer light gold
  static const fblaPaleGold = Color(0xFFF5C866); // Soft peachy gold
  static const fblaAmber = Color(0xFFB87A15); // Deep amber

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
        return fblaNavyDark;
      case EventCategory.presentation:
        return fblaBrightBlue;
      case EventCategory.roleplay:
        return fblaGold;
    }
  }

  Color _getCategoryAccentColor() {
    switch (event.category) {
      case EventCategory.objective:
        return fblaNavyMid;
      case EventCategory.presentation:
        return fblaSkyBlue;
      case EventCategory.roleplay:
        return fblaLightGold;
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
    final accentColor = _getCategoryAccentColor();
    final isGoldCategory = event.category == EventCategory.roleplay;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            categoryColor.withOpacity(0.04),
            accentColor.withOpacity(0.08),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: 1.3,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: categoryColor.withOpacity(0.1),
          highlightColor: accentColor.withOpacity(0.05),
          onTap: _openLink,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: category badge + link icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor,
                            accentColor,
                            categoryColor.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: categoryColor.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(),
                            size: 16,
                            color: isGoldCategory ? fblaNavyDark : Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.category.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isGoldCategory
                                  ? fblaNavyDark
                                  : Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.open_in_new_rounded,
                        color: categoryColor.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Event Title
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: fblaNavyDark,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Decorative divider with gradient
                Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        categoryColor,
                        accentColor,
                        categoryColor.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: Colors.grey[800],
                    height: 1.55,
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
