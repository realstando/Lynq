class Resource {
  Resource({required this.title, required this.link, required this.body});

  final String title;
  final String link;
  final String body;

  @override
  String toString() {
    return 'Resource(title: $title, link: $link, body: $body)';
  }
}
