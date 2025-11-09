import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsFormat extends StatelessWidget {
  final CompetitiveEvent event;

  const EventsFormat({super.key, required this.event});

  void _openLink() async {
    final Uri url = Uri.parse(event.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch ${event.link}");
    }
  }

  // Enhanced category color palette (more saturation and contrast)
  Color _getCategoryColor() {
    switch (event.category) {
      case EventCategory.objective:
        return const Color(0xFF2563EB); // Vibrant royal blue
      case EventCategory.presentation:
        return const Color(0xFF7C3AED); // Deep purple
      case EventCategory.roleplay:
        return const Color(0xFFE11D48); // Bold pink-red
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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            categoryColor.withOpacity(0.06),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: categoryColor.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: categoryColor.withOpacity(0.08),
          highlightColor: Colors.transparent,
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
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withOpacity(0.85),
                            categoryColor.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: categoryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.category.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.open_in_new_rounded,
                      color: categoryColor.withOpacity(0.6),
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Event Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Decorative divider
                Container(
                  height: 2,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        categoryColor.withOpacity(0.9),
                        categoryColor.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
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
