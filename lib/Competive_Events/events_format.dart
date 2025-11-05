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

  Color _getCategoryColor() {
    switch (event.category) {
      case EventCategory.objective:
        return const Color(0xFF6366F1); // Indigo
      case EventCategory.presentation:
        return const Color(0xFF8B5CF6); // Purple
      case EventCategory.roleplay:
        return const Color(0xFFEC4899); // Pink
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _openLink,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                _getCategoryColor().withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getCategoryColor().withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(),
                          size: 16,
                          color: _getCategoryColor(),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          event.category.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Link Icon
                  Icon(
                    Icons.open_in_new,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
