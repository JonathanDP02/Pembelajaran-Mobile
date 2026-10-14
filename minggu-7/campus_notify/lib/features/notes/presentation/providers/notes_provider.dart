import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => LocalNotesRepository(),
);

final notesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  return repository.fetchNotes();
});
