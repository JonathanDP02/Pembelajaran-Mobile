class Note {
  const Note({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;
}

abstract interface class NotesRepository {
  Future<List<Note>> fetchNotes();
}

class LocalNotesRepository implements NotesRepository {
  @override
  Future<List<Note>> fetchNotes() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const [
      Note(
        id: 1,
        title: 'Kegiatan hari ini',
        body: 'Ikuti briefing pagi dan cek pengumuman kampus.',
      ),
      Note(
        id: 2,
        title: 'Tugas',
        body: 'Upload laporan praktikum dan validasi notifikasi.',
      ),
      Note(
        id: 3,
        title: 'Catatan penting',
        body: 'Gunakan token FCM yang aman dan jangan tampilkan token lengkap.',
      ),
    ];
  }
}
