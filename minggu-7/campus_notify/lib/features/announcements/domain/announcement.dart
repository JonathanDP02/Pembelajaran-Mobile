class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    this.body = '',
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;
}
