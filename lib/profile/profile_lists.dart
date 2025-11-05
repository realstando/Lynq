import 'package:intl/intl.dart';

class ProfileEvents {
  const ProfileEvents({
    required this.eventName,
    required this.eventDate,
  });
  final String eventName;
  final DateTime eventDate;

  String get formattedDate {
    final formatter = DateFormat('E, MMM d \'@\' h:mm a');
    return formatter.format(eventDate);
  }
}