enum HomeCategory { announcement, event, update }

class HomeItem {
  final String title;
  final String description;
  final HomeCategory category;
  final String link;

  HomeItem({
    required this.title,
    required this.description,
    required this.category,
    required this.link,
  });
}
