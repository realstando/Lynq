class Resource {
  Resource({required this.title, required this.link, required this.body, required this.code});

  final String title;
  final String link;
  final String body;
  final String code;

  @override
  String toString() {
    return 'Resource(title: $title, link: $link, body: $body)';
  }
}
