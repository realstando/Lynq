import 'package:flutter/material.dart';

/// A reusable card widget for displaying event information in a list
/// Features a tappable surface with an event icon, name, and forward arrow
/// Used in lists of upcoming or past events
class EventCard extends StatelessWidget {
  /// The name/title of the event to display
  final String eventName;

  const EventCard({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Add vertical spacing between cards in a list
      margin: const EdgeInsets.symmetric(vertical: 6),
      // Rounded corners for modern, friendly appearance
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Leading icon - calendar/event icon to indicate this is an event
        leading: const Icon(Icons.event, color: Colors.blue),
        // Main content - the event name
        title: Text(eventName),
        // Trailing icon - forward arrow indicates this card is tappable
        // and will navigate to more details
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        // Tap handler - currently empty but designed for navigation
        onTap: () {
          // TODO: Navigate to event details page
          // Example: Navigator.push(context, MaterialPageRoute(...))
        },
      ),
    );
  }
}

/// A reusable card widget for displaying scheduled activities
/// Shows activity name with associated time/schedule information
/// Non-interactive display card (no tap functionality)
class ActivityCard extends StatelessWidget {
  /// The name/description of the activity
  final String activity;

  /// The time or schedule information for the activity
  /// Could be a specific time (e.g., "2:00 PM") or duration (e.g., "2 hours")
  final String time;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Add vertical spacing between cards in a list
      margin: const EdgeInsets.symmetric(vertical: 6),
      // Rounded corners matching EventCard for consistent styling
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Leading icon - clock/schedule icon to indicate time-based activity
        leading: const Icon(Icons.schedule, color: Colors.deepPurple),
        // Main content - the activity name/description
        title: Text(activity),
        // Secondary content - time information shown below the title
        subtitle: Text(time),
        // Note: No onTap or trailing arrow since this is informational only
      ),
    );
  }
}
