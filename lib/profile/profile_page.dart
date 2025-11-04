import 'package:coding_prog/profile/profile_lists.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final String profileImage = 'https://via.placeholder.com/150';
    final String name = 'Ryan Wang';
    final String school = 'Stanford University';
    final List<String> events = [
      'FLC',
      'NCCC',
      'Event Deadline',
    ];
    final List<ProfileEvents> activities = [
      ProfileEvents(eventDate: DateTime(2025, 11, 8, 9), eventName: 'Team Stand-up'),
      ProfileEvents(eventDate: DateTime(2025, 11, 22, 7), eventName: 'NCCC'),
      ProfileEvents(eventDate: DateTime(2026, 2, 4, 8, 30), eventName: 'Regionals'),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      school,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('My Events'),
            const SizedBox(height: 8),
            Column(
              children: events
                  .map((event) => EventCard(eventName: event))
                  .toList(),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Scheduled Activities'),
            const SizedBox(height: 8),
            Column(
              children: activities
                  .map((activity) => ActivityCard(
                        activity: activity.eventName,
                        time: activity.formattedDate,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


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

