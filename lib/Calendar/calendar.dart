import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Calendar {
  Calendar(this.event, this.title, this.date, this.location);

  final String event;
  final String title;
  final DateTime date;
  final String location;

  String get formattedDate {
    return formatter.format(date);
  }
}
