import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Announcement {
  const Announcement({
    required this.name,
    required this.title,
    required this.content,
    required this.date,
    required this.initial,
    required this.code,
  });
  final String initial;
  final String name;
  final String title;
  final String content;
  final DateTime date;
  final String code;

  String get formattedDate {
    return formatter.format(date);
  }
}
