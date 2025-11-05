import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Calendar {
  Calendar(this.event, this.date, this.location);

  final String event;
  final DateTime date;
  final String location;

  String get formattedDate {
    return formatter.format(date);
  }
}
