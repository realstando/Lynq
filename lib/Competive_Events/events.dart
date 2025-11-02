enum EventCategory { roleplay, objective, presentation }

class CompetitiveEvent {
  final String title;
  final EventCategory category;
  final String description;
  final String link;

  CompetitiveEvent({
    required this.title,
    required this.category,
    required this.description,
    required this.link,
  });
}
