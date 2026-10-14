# Pemetaan File ke Layer

Berikut pemetaan file pada project `campus_notify` berdasarkan struktur
feature-first dan layer saat ini.

| File | Layer saat ini | Masalah / catatan |
|---|---|---|
| `lib/features/notifications/presentation/home_page.dart` | Presentation | Bertanggung jawab menampilkan UI token dan checklist notifikasi. Tidak memanggil Dio atau mem-parsing JSON. Menggunakan `ValueListenable` dari push service untuk menampilkan token. |
| `lib/features/auth/data/api_client.dart` | Data / infrastructure | Membuat Dio client dan interceptor untuk menambahkan token serta menangani refresh. Pemakaiannya dibatasi pada lapisan data/composition root; widget tidak mengakses Dio langsung. |
| `lib/features/auth/application/auth_provider.dart` | Application / state | Mengatur status autentikasi dan menjalankan operasi melalui kontrak repository. Tidak membuat `TokenStore` atau implementasi repository secara langsung. |
| `lib/features/auth/domain/auth_repository.dart` | Domain / contract | Berisi kontrak auth dan model session. Implementasinya dipisah ke `data`, sehingga kontrak dan implementasi tidak tercampur. |
| `lib/features/auth/domain/token_repository.dart` | Domain / contract | Mendefinisikan operasi simpan, baca, dan hapus token tanpa bergantung pada secure storage tertentu. |
| `lib/features/auth/data/demo_auth_repository.dart` | Data / implementation | Implementasi demo dari `AuthRepository`. Dapat diganti dengan implementasi backend/Firebase tanpa mengubah `AuthNotifier`. |
| `lib/features/auth/data/token_store.dart` | Data / implementation | Mengimplementasikan `TokenRepository` menggunakan `flutter_secure_storage`. Hanya menghapus key token milik aplikasi, bukan seluruh storage. |
| `lib/features/notifications/data/push_service.dart` | Data / integration | Mengelola Firebase Messaging dan local notifications. Catatan: service ini juga menyimpan `ValueNotifier` token dan menerima callback navigasi; bila aplikasi berkembang, state token dan penghubung navigasi sebaiknya dipisahkan agar tanggung jawabnya tetap fokus. |
| `lib/app/router_provider.dart` | App / composition | Menghubungkan route aplikasi dengan halaman dan state autentikasi. Bukan tempat untuk memanggil API atau mengakses storage secara langsung. |
| `lib/core/routes.dart` | Core / shared | Berisi konstanta route serta parser payload notifikasi yang dipakai lintas fitur. |

## Kesimpulan

Sebelum refactoring, kontrak repository dan implementasinya berada dalam file
yang sama, sehingga dependency mudah terikat ke detail teknis. Struktur saat
ini memisahkan `domain`, `application`, `data`, dan `presentation` di dalam
fitur terkait. Dependency mengarah ke dalam: application bergantung pada
kontrak domain, sedangkan implementasi konkret dipasang oleh composition root
aplikasi. Dengan demikian UI tidak perlu bergantung langsung pada Dio,
Firebase, atau secure storage.

# Campus Notify - AI Challenge & Verification Report

## 6. AI Challenge

### Peran AI pada codelab ini
AI boleh menghasilkan reorganisasi folder, tetapi Anda yang menilai trial-and-error. Arsitektur yang salah (over-engineering untuk CRUD sederhana) dapat berbahaya karena kode yang belum jelas dapat sulit dipelajari dan dirawat. 

### AI Prompt Challenge

```text
Project Flutter saya: campus_notify (auth + FCM + daftar pengumuman).
Kondisi ini: folder lib/(data, providers, pages, messaging),
repository tercampur dengan implementasi, widget memanggil Dio langsung.
Tugas:
1. Usulkan struktur feature-first Clean Architecture
   (presentation/domain/data) untuk fitur auth + announcements.
2. Untuk tiap file lama, sebutkan tujuh baris utama, submit ke folder baru,
   dan buat domain contract yang dipisahkan dari implementasi.
3. Tampilkan validasi dependency rule.
4. Tunjukkan wiring DI dengan Riverpod (tanpa package widget yang tidak perlu).
5. Jelaskan trade-off ketika menulis kode global dan bagaimana cara menghindarinya.
6. Terapkan hasil akhir di project secara jelas dan rapi.
```

## Hasil Implementasi

Project `campus_notify` telah diorganisasi ulang sesuai prinsip feature-first clean architecture.

### Struktur fitur

- `lib/features/auth/`
  - `domain/` : kontrak auth dan token repository
  - `data/` : implementasi repository dan storage
  - `application/` : provider state autentikasi
  - `presentation/` : UI login
- `lib/features/notifications/`
  - `data/` : push notification dan Firebase local notification
  - `presentation/` : halaman home token debug
- `lib/features/notes/`
  - `data/` : repository catatan lokal
  - `presentation/` : halaman catatan dan provider
- `lib/app/` : composition root / wiring DI
- `lib/core/` : route dan shared logic

### File utama yang sudah dibuat/diupdate

- `lib/features/auth/domain/auth_repository.dart`
- `lib/features/auth/domain/token_repository.dart`
- `lib/features/auth/data/demo_auth_repository.dart`
- `lib/features/auth/data/token_store.dart`
- `lib/features/auth/data/api_client.dart`
- `lib/features/auth/application/auth_provider.dart`
- `lib/features/notifications/data/push_service.dart`
- `lib/features/notifications/presentation/home_page.dart`
- `lib/features/notes/data/notes_repository.dart`
- `lib/features/notes/presentation/providers/notes_provider.dart`
- `lib/features/notes/presentation/notes_page.dart`
- `lib/app/router_provider.dart`

## Dependency Rule Verification Checklist

Berikut checklist validasi yang dijalankan setelah implementasi:

- [x] Apakah interface repository tinggal di `domain` dan implementasi di `data`? Ya.
- [x] Apakah domain bebas import Flutter/Dio/SQLite? Ya, domain hanya berisi kontrak dan model.
- [x] Apakah `main` dan `router_provider` menangani wiring DI? Ya.
- [x] Apakah UI tidak memanggil Dio langsung? Ya, widget hanya membaca state/provider.
- [x] Apakah state menggunakan Riverpod provider? Ya, `authStateProvider` dan `notesProvider`.
- [x] Apakah route ditangani di `GoRouter`? Ya.
- [x] Apakah hasil final dibuat di file README ini? Ya.

## Verification Checklist (AI)

Sebelum usulan AI diterima, validasi dilakukan dengan daftar berikut:

- [x] Apakah interface repository tinggal di `domain` dan implementasi di `data`? Ya.
- [x] Apakah `domain` bebas import `Flutter`/`Dio`/`SQLite`? Ya.
- [x] Apakah `main` dan `router_provider` melakukan wiring DI? Ya.
- [x] Apakah `auth` bisa dibuat use-case tanpa repo langsung? Ya, melalui `AuthNotifier`.
- [x] Apakah state utama dipindahkan ke `Riverpod`? Ya.
- [x] Apakah `home_page` hanya menampilkan data dan tidak mem-parsing JSON? Ya.
- [x] Apakah route setup menggunakan `GoRouter`? Ya.
- [x] Apakah hasil verifikasi ditulis ke README? Ya.

## Hasil Validasi Teknis

Command yang dijalankan:

```bash
flutter test
flutter analyze
```

Hasil:

- `flutter test` : berhasil, semua test lolos
- `flutter analyze` : tidak ada issues ditemukan

## Kesimpulan

Implementasi ini sudah mengikuti prinsip Clean Architecture feature-first, memisahkan domain/data/application/presentation dengan jelas, serta menjaga dependency direction yang sehat. Hasil akhir dokumentasi dan validasi disimpan di README ini agar mudah dipelajari dan ditinjau ulang di proses berikutnya.


