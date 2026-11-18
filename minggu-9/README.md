# Minggu 9 — AI-Assisted Development

Fitur minggu ini menambahkan pencarian **judul catatan** ke aplikasi Flutter
`campus_notify` dari minggu-7. Pencarian mengabaikan kapitalisasi dan spasi tepi,
menampilkan empty state jika hasil tidak ditemukan, dan tidak mencari isi/body
catatan.

## Stack dan struktur

- Flutter / Dart SDK `^3.13.2`
- `flutter_riverpod ^3.4.3` untuk state
- Data catatan demo lokal dari `LocalNotesRepository`; fitur ini tidak menambah
  SQLite, Dio, package, atau konfigurasi rahasia

```text
campus_notify/
  lib/features/notes/
    application/notes_provider.dart       # state query, provider, use-case wiring
    data/notes_repository.dart            # implementasi sumber data lokal
    domain/
      get_notes.dart
      note.dart
      note_repository.dart                # kontrak domain
      search_notes.dart                   # filter murni, tanpa Flutter/database
    presentation/notes_page.dart          # search field, daftar, empty state
  test/
    search_filter_test.dart
    notes_search_widget_test.dart
```

Dependency search mengalir dari UI ke provider/application, lalu ke fungsi
domain `SearchNotes`; implementasi repository dipasang oleh composition root di
`lib/main.dart`. Filter domain tidak mengimpor Flutter, Dio, atau database dan
widget tidak memanggil repository/database.

## Prompt dan konteks AI

Prompt inti memakai lima slot:

1. **Peran:** senior Flutter developer.
2. **Konteks:** app `campus_notify`, feature-first, kontrak repository di
   `domain`, implementasi di `data`, Riverpod `^3.4.3`, Dart `^3.13.2`.
3. **Tugas:** cari judul catatan, abaikan kapitalisasi/spasi tepi, tampilkan
   hasil dan empty state.
4. **Batas:** hanya judul; jangan mengubah repository atau menambah package;
   UI tidak mengakses data; domain harus murni dan hasil mudah diuji.
5. **Output:** usulan kode kecil, unit test cocok/tidak cocok, widget test, dan
   cara verifikasi.

Prompt mentah dan potongan konteks yang dibagikan ada di
[docs/ai-log.md](docs/ai-log.md). Tidak ada token, API key, password, atau
rahasia yang diberikan ke AI.

## Verifikasi bug dan perbaikan

Draft awal AI menggunakan `note.title.contains(query.trim())`. API `contains`
valid, tetapi perbandingan string tersebut peka kapitalisasi. Saya menguji
query `kEGIATAN` terhadap judul `Kegiatan hari ini` sebelum perbaikan:

```text
flutter test test/search_filter_test.dart
Expected: an object with length of <1>
Actual: []
Failing test: search judul tidak sensitif huruf besar-kecil dan spasi tepi
```

**Akar masalah:** query dan judul dibandingkan tanpa normalisasi huruf.
`SearchNotes` kini memangkas spasi tepi, mengubah query serta judul menjadi
lowercase, lalu hanya mencari di judul. Test merah di atas adalah bukti
reproduksi; test yang sama menjadi hijau setelah perbaikan.

Pemeriksaan batas arsitektur dengan `rg` pada `lib/features/notes/domain/`
untuk `package:flutter`, `package:dio`, `sqflite`, dan `sqlite` tidak
menemukan import; pencarian `features/notes/data`, `LocalNotesRepository`,
`Dio`, `Database`, dan `db.query` pada presentation juga tidak menemukan
panggilan data langsung.

## AI Challenge: review dan keputusan

Prompt review dan tabel lengkap usulan-vs-keputusan ada di
[docs/ai-log.md](docs/ai-log.md). Ringkasannya:

| Temuan/usulan | Bukti | Keputusan |
|---|---|---|
| `String.contains` pada judul peka kapitalisasi | Test merah untuk `kEGIATAN` vs `Kegiatan hari ini` | **Terima + perbaiki**: normalisasi query dan judul. |
| Query/state dan implementasi repository tercampur di provider presentation | Review struktur provider dan wiring aplikasi | **Terima + refactor**: state dipindah ke `application`, implementasi repository dipasang dari `main.dart`. |
| Cari pula di `body`, atau ganti sumber demo dengan query SQL/indeks | Jobsheet meminta pencarian judul; notes masih memakai tiga data lokal demo | **Tolak**: memperluas spesifikasi dan menambahkan kompleksitas/data source yang tidak ada. |

### Refleksi

- **Halusinasi/kesalahan AI:** AI memakai API Dart yang benar (`String.contains`)
  tetapi menganggap pencarian itu tidak peka kapitalisasi. Test regresi dengan
  `kEGIATAN` membuktikan hasil salah sebelum perbaikan.
- **Prompt paling membantu:** prompt lima slot yang menyebut arsitektur, batas
  “judul saja”, normalisasi query, empty state, dan test. Saya memperjelas kasus
  kapitalisasi/spasi serta menolak perubahan repository/package yang tidak
  diperlukan.
- **Refactor dari draft AI:** pemfilteran dipindahkan ke use case domain murni;
  state query ada di application/provider; UI hanya mengirim query dan
  menampilkan state. Wiring repository dilakukan di composition root.
- **Keputusan paling sulit:** menolak pencarian body / SQL demi “performa”.
  Secara teknis itu mungkin berguna pada skala lain, tetapi tidak sesuai
  tugasnya, dan jalur catatan ini saat ini hanya mengembalikan tiga data demo
  lokal.

## Bukti pengujian

Jalankan dari folder proyek:

```powershell
cd .\minggu-9\campus_notify
flutter pub get
flutter analyze
dart format --set-exit-if-changed .
flutter test
```

**Hasil akhir yang diverifikasi:**

| Pemeriksaan | Hasil |
|---|---|
| `flutter analyze` | Lulus, tidak ada issue. |
| `dart format --set-exit-if-changed .` | Lulus, tidak ada file yang perlu diformat ulang. |
| `flutter test` | Lulus; 16 test unit/widget, termasuk test fitur search, lolos. |
| Dependency domain/presentation | `rg` tidak menemukan import/call lintas-layer yang dilarang pada fitur notes. |
| Screenshot state UI | Widget test menghasilkan screenshot query kosong, cocok, dan tak cocok di bawah `screenshots/`. |

Screenshot adalah render dari Flutter widget test, bukan foto/screenshot
emulator. Uji widget mencakup tiga keadaan: query kosong menampilkan semua
catatan, `kEGIATAN` menemukan judul secara case-insensitive, dan `Briefing`
(hanya muncul di body) menampilkan `Tidak ada catatan yang cocok.` Perangkat
fisik/emulator tidak diklaim telah diuji.

## Cara menjalankan

```powershell
cd .\minggu-9\campus_notify
flutter pub get
flutter run
```

Buka **Buka Catatan Kuliah**, lalu ketik query di **Cari judul catatan**.
Tombol hapus membersihkan query; query kosong mengembalikan seluruh catatan.
Sumber data masih data demo yang sudah ada di repository minggu-7.

## Screenshot

- [Query kosong](screenshots/query-empty.png)
- [Query cocok](screenshots/query-match.png)
- [Query tidak cocok / empty state](screenshots/query-no-match.png)

Screenshot dihasilkan dan dibandingkan oleh widget test; bukan bukti runtime
Firebase/backend atau screenshot dari emulator.
