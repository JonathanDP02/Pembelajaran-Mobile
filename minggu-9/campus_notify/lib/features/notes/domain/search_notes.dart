import 'note.dart';

class SearchNotes {
  const SearchNotes();

  List<Note> call(List<Note> notes, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return List<Note>.of(notes);

    return notes
        .where((note) => note.title.toLowerCase().contains(normalizedQuery))
        .toList();
  }
}
