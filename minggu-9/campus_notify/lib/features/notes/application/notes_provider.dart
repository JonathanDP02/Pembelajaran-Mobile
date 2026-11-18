import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/failure.dart';
import '../domain/get_notes.dart';
import '../domain/note.dart';
import '../domain/note_repository.dart';
import '../domain/search_notes.dart';

final notesRepositoryProvider = Provider<NoteRepository>((ref) {
  throw StateError(
    'notesRepositoryProvider must be configured by the application.',
  );
});

final notesProvider = FutureProvider<({List<Note> notes, Failure? failure})>((
  ref,
) async {
  final repository = ref.watch(notesRepositoryProvider);
  return GetNotes(repository).call();
});

final notesSearchQueryProvider = NotifierProvider<NotesSearchQuery, String>(
  NotesSearchQuery.new,
);

class NotesSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final filteredNotesProvider =
    Provider<AsyncValue<({List<Note> notes, Failure? failure})>>((ref) {
      final result = ref.watch(notesProvider);
      final query = ref.watch(notesSearchQueryProvider);

      return result.whenData((value) {
        if (value.failure != null) return value;

        return (
          notes: const SearchNotes().call(value.notes, query),
          failure: null,
        );
      });
    });
