# AI Log — Minggu 9

## Prompt inti mentah (5 slot)

```text
Peran: Bertindak sebagai senior Flutter developer.

Konteks: Saya mengerjakan aplikasi Flutter campus_notify, Dart SDK ^3.13.2,
flutter_riverpod ^3.4.3, dan feature-first architecture. Note berada di
features/notes/domain/note.dart. NoteRepository adalah kontrak domain di
features/notes/domain/note_repository.dart; LocalNotesRepository adalah
implementasi sumber data demo di features/notes/data/notes_repository.dart.
Saat ini NotesPage membaca notesProvider dan menampilkan semua catatan.
Catatan demo memiliki title dan body.

Tugas: Tambahkan pencarian judul catatan. Pencarian harus mengabaikan
kapitalisasi dan spasi di awal/akhir query. Tampilkan empty state bila tidak
ada judul yang cocok.

Batasan: Cari title saja, jangan body. Jangan panggil repository/database dari
widget. Jangan menambah package atau mengubah implementasi repository. Letakkan
filter sebagai fungsi/use case domain murni tanpa import Flutter. Batasi
perubahan kode pada fitur ini dan jaga setiap fungsi tetap kecil.

Output: Berikan rancangan singkat, kode yang diperlukan, satu unit test untuk
hasil cocok/case-insensitive, satu test untuk query yang tidak cocok, satu
widget test untuk empty state, serta perintah analyze/format/test.
```

## Konteks yang diberikan

```dart
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

abstract interface class NoteRepository {
  Future<({List<Note> notes, Failure? failure})> fetchNotes();
}
```

Versi relevan dari `pubspec.yaml`: Dart `^3.13.2` dan
`flutter_riverpod ^3.4.3`. Tidak ada secret, token, atau seluruh isi repository
yang ditempel.

## Output awal AI (sebelum diverifikasi)

```dart
List<Note> filterNotes(List<Note> notes, String query) {
  if (query.trim().isEmpty) return notes;
  return notes.where((note) => note.title.contains(query.trim())).toList();
}
```

Draft ringkas ini hanya cocok untuk query dengan kapitalisasi yang sama.
Method `contains` memang ada di `String`, tetapi AI tidak membuktikan
semantiknya terhadap kebutuhan pencarian case-insensitive. Saya tidak menerima
draft tersebut mentah-mentah.

## Verifikasi, reproduksi, dan perbaikan

1. **Baca kode:** `String.contains` melakukan pencocokan peka kapitalisasi.
2. **Cek batas layer:** filter dipisahkan ke `domain/search_notes.dart`; file
   domain tidak bergantung pada Flutter, Dio, atau SQLite.
3. **Cek API:** hanya memakai API Dart standar `trim`, `toLowerCase`, dan
   `contains`; tidak ada method/package fiktif.
4. **Test merah:** ketika filter masih memakai `note.title.contains(query)`,
   `flutter test test/search_filter_test.dart` dengan query `kEGIATAN` terhadap
   `Kegiatan hari ini` gagal: `Expected length 1; Actual []`.
5. **Perbaiki kecil:** normalisasi query dan title ke lowercase, lalu cari
   hanya di title.
6. **Test hijau akhir:** unit test mencakup cocok/case-insensitive + spasi
   tepi, tidak cocok, dan query kosong. Widget test mencakup query kosong,
   cocok, serta query yang hanya ada di body sebagai empty state.

## Prompt AI Challenge

```text
Review kode search Flutter ini sebagai senior developer.
Konteks: feature-first (presentation -> application -> domain <- data),
Riverpod ^3.4.3, source catatan demo lokal. Fokus: kebenaran, dependency
direction, dan test; abaikan style. Berikan tepat 3 temuan. Untuk setiap
temuan beri severity blocker/saran, alasan teknis, dan bukti yang harus dicek.
Jangan menyarankan perubahan package atau backend tanpa kebutuhan terukur.
```

## Hasil review: usulan vs keputusan

| # | Temuan AI | Severity | Bukti/penilaian | Keputusan |
|---|---|---|---|---|
| 1 | `String.contains` membuat pencarian peka kapitalisasi. | Blocker untuk acceptance | Test query `kEGIATAN` gagal pada judul `Kegiatan hari ini` sebelum normalisasi; setelah perubahan test yang sama lolos. | **Terima + perbaiki** dengan `trim().toLowerCase()` pada query dan title. |
| 2 | State query/provider dan repository konkret sebaiknya tidak dicampur ke presentation. | Saran | Pemeriksaan import menunjukkan provider presentation lama mengimpor data langsung. Composition root sudah ada di `main.dart`. | **Terima + refactor**: provider state dipindah ke `application`; `LocalNotesRepository` di-wire dari `main.dart`. |
| 3 | Tambahkan pencarian body serta ganti demo dengan SQL `LIKE` dan indeks agar lebih siap skala besar. | Saran | Jobsheet menyebut pencarian judul; repository saat ini memberi tiga catatan lokal demo dan tidak memakai database untuk notes. | **Tolak**: di luar scope, memerlukan backend/database yang tidak ada, dan pencarian body dapat menghasilkan hasil yang spesifikasi tidak minta. |

## Hasil akhir

- File filter: `campus_notify/lib/features/notes/domain/search_notes.dart`
- Provider/wiring state: `campus_notify/lib/features/notes/application/notes_provider.dart`
- UI: `campus_notify/lib/features/notes/presentation/notes_page.dart`
- Unit test: `campus_notify/test/search_filter_test.dart`
- Widget test: `campus_notify/test/notes_search_widget_test.dart`
- Screenshot widget-test: `screenshots/query-empty.png`,
  `screenshots/query-match.png`, `screenshots/query-no-match.png`
- Hasil akhir `flutter analyze`, `dart format --set-exit-if-changed .`, dan
  `flutter test` dicatat di README setelah validasi.
