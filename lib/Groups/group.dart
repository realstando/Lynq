import 'dart:math';

class Group {
  Group({required this.name}) : code = _generateAlphanumericCode();
  String name;
  String code;
  static String _generateAlphanumericCode({int length = 6}) {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Excludes confusing chars
    final random = Random();

    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
