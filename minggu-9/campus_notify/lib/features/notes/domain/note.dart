class Note {
  const Note({
    this.id,
    required this.title,
    this.body = '',
    required this.updatedAt,
  });

  final int? id;
  final String title;
  final String body;
  final DateTime updatedAt;
}
