import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventName;

  const EventCard({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.blue),
        title: Text(eventName),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // You could navigate to event details here
        },
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String activity;
  final String time;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.schedule, color: Colors.deepPurple),
        title: Text(activity),
        subtitle: Text(time),
      ),
    );
  }
}
