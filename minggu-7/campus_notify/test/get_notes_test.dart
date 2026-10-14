import 'package:campus_notify/core/failure.dart';
import 'package:campus_notify/features/notes/domain/get_notes.dart';
import 'package:campus_notify/features/notes/domain/note.dart';
import 'package:campus_notify/features/notes/domain/note_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNoteRepository implements NoteRepository {
  FakeNoteRepository({this.items = const [], this.fail = false});

  final List<Note> items;
  final bool fail;

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    if (fail) {
      return (
        notes: const <Note>[],
        failure: const LocalFailure('db locked (simulasi)'),
      );
    }
    return (notes: items, failure: null);
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test('GetNotes meneruskan daftar dari repository', () async {
    final repo = FakeNoteRepository(items: [
      Note(
        id: 1,
        title: 'A',
        body: '',
        updatedAt: DateTime(2026, 9, 27),
      ),
    ]);
    final result = await GetNotes(repo).call();
    expect(result.failure, isNull);
    expect(result.notes.length, 1);
    expect(result.notes.first.title, 'A');
  });

  test('GetNotes meneruskan failure tanpa melempar', () async {
    final repo = FakeNoteRepository(fail: true);
    final result = await GetNotes(repo).call();
    expect(result.failure, isA<LocalFailure>());
    expect(result.notes, isEmpty);
  });
}
