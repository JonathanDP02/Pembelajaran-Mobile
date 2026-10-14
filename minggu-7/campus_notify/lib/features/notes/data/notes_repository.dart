import '../../../core/failure.dart';
import '../domain/note.dart';
import '../domain/note_repository.dart';

class LocalNotesRepository implements NoteRepository {
  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));

      return (
        notes: [
          Note(
            id: 1,
            title: 'Kegiatan hari ini',
            body: 'Ikuti briefing pagi dan cek pengumuman kampus.',
            updatedAt: DateTime(2026, 9, 27),
          ),
          Note(
            id: 2,
            title: 'Tugas',
            body: 'Upload laporan praktikum dan validasi notifikasi.',
            updatedAt: DateTime(2026, 9, 28),
          ),
          Note(
            id: 3,
            title: 'Catatan penting',
            body: 'Gunakan token FCM yang aman dan jangan tampilkan token lengkap.',
            updatedAt: DateTime(2026, 9, 29),
          ),
        ],
        failure: null,
      );
    } on Exception {
      return (
        notes: const <Note>[],
        failure: const LocalFailure('Gagal memuat catatan. Silakan coba lagi.'),
      );
    }
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      updatedAt: DateTime.now(),
    );

    return (note: note, failure: null);
  }
}
