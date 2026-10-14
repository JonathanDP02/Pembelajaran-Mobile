import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure.dart';
import '../../data/notes_repository.dart';
import '../../domain/get_notes.dart';
import '../../domain/note.dart';
import '../../domain/note_repository.dart';

final notesRepositoryProvider = Provider<NoteRepository>(
  (ref) => LocalNotesRepository(),
);

final notesProvider = FutureProvider<({List<Note> notes, Failure? failure})>((ref) async {
  final repository = ref.watch(notesRepositoryProvider);
  return GetNotes(repository).call();
});
