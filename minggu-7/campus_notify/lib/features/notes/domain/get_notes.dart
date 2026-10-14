import '../../../core/failure.dart';
import 'note.dart';
import 'note_repository.dart';

class GetNotes {
  const GetNotes(this.repository);

  final NoteRepository repository;

  Future<({List<Note> notes, Failure? failure})> call() async {
    try {
      return await repository.fetchNotes();
    } on Failure catch (failure) {
      return (notes: const <Note>[], failure: failure);
    } on Exception {
      return (
        notes: const <Note>[],
        failure: const LocalFailure('Gagal memuat catatan. Silakan coba lagi.'),
      );
    }
  }
}
