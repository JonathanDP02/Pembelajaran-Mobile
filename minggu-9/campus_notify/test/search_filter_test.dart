import 'package:campus_notify/features/notes/domain/note.dart';
import 'package:campus_notify/features/notes/domain/search_notes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final notes = [
    Note(
      id: 1,
      title: 'Kegiatan hari ini',
      body: 'Briefing pagi',
      updatedAt: DateTime(2026, 9, 27),
    ),
    Note(
      id: 2,
      title: 'Tugas',
      body: 'Laporan praktikum',
      updatedAt: DateTime(2026, 9, 28),
    ),
  ];
  const searchNotes = SearchNotes();

  test('search judul tidak sensitif huruf besar-kecil dan spasi tepi', () {
    expect(searchNotes(notes, '  kEGIATAN  '), hasLength(1));
    expect(
      searchNotes(notes, '  kEGIATAN  ').single.title,
      'Kegiatan hari ini',
    );
  });

  test('query yang tidak cocok mengembalikan daftar kosong', () {
    expect(searchNotes(notes, 'zzz-tak-ada'), isEmpty);
  });

  test('query kosong mengembalikan semua catatan', () {
    expect(searchNotes(notes, '  '), hasLength(2));
  });
}
