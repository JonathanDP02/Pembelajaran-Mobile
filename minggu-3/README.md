# minggu 3

# konsep navigasi dan GoRouter

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.36.jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.36(1).jpeg)

# state management dengan riverpod

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.36(2).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.36(3).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.37.jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.37(1).jpeg)

# AsyncValue: loading, error, success
# Praktikum 3 — Uji ketiga state

1. Salin kode di atas ke project ToDo Anda (atau project terpisah) dan jalankan. Amati tampilan loading selama 2 detik pertama.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

2. Ubah build() sementara untuk melempar error: throw Exception('Gagal terhubung ke server');. Jalankan dan amati UI error beserta tombol Coba lagi.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38.jpeg)

3. Tekan tombol Coba lagi, ref.invalidate membuat provider dijalankan ulang. Pulihkan kode, pastikan state success tampil.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

4. Refleksikan: mengapa menampilkan ulang data lama (stale data) dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola itu penting?

jawab: 
- Menampilkan data lama (stale data) dengan indikator refresh jauh lebih baik daripada mengosongkan layar karena menjaga kenyamanan visual (user experience). Pengguna tidak terganggu oleh efek flicker atau layar kosong mendadak, serta aplikasi terasa lebih cepat dan responsif karena informasi masih bisa dibaca selagi data baru dimuat di latar belakang.

- Pola ini sangat penting diterapkan pada fitur pull-to-refresh (seperti feed media sosial atau katalog produk), pembaruan data berkala (real-time/polling), serta kondisi jaringan yang kurang stabil agar pengguna tetap memiliki konteks informasi.


# AI Challenge

## 1. Prompt Asli (AI Prompt)

Prompt berikut digunakan pada AI coding assistant untuk memicu pembuatan kode awal:

> "Buatkan halaman Flutter bernama StatsPage menggunakan flutter_riverpod.  
> **Requirements:**  
> - ConsumerWidget dengan satu AsyncNotifierProvider yang mensimulasikan pengambilan data statistik (delay 2 detik, kadang gagal 30%).  
> - UI harus menangani loading (spinner), error (pesan + tombol retry), dan success (ListView 3 item).  
> - Berikan unit test untuk notifier-nya.  
> Jelaskan setiap bagian kode dalam komentar."

---

## 2. AI Verification Checklist & Temuan

Sebelum kode diterima dan digabungkan ke dalam proyek, verifikasi berikut telah dilakukan:

## Tabel Verifikasi Kriteria

| No | Kriteria Verifikasi | Status | Catatan / Temuan |
|---|---|---|---|
| 1 | **Immutability State** | ✅ Pass | List data dikembalikan sebagai objek baru, tidak menggunakan `.add()` atau memutasi `state` langsung. |
| 2 | **Penggunaan `ref` yang Tepat** | ✅ Pass | `ref.watch` hanya digunakan di dalam method `build()`, sedangkan `ref.invalidate` dipanggil di dalam *callback* `onPressed`. |
| 3 | **Handling 3 State `AsyncValue`** | ✅ Pass | UI menangani kondisi `loading`, `error` (dengan tombol retry), dan `data` menggunakan method `.when()`. |
| 4 | **Tipe Provider Eksplisit** | ✅ Pass | Provider dideklarasikan dengan tipe data eksplisit `AsyncNotifierProvider<StatsNotifier, List<String>>`. |
| 5 | **Pola Riverpod Modern (2.x)** | ✅ Pass | Menggunakan `AsyncNotifier` dan `ConsumerWidget`, bukan `StateNotifierProvider` atau `StateProvider` yang *deprecated*. |
| 6 | **Analisis & Testing Kode** | ⚠️ Partial | `flutter analyze` lolos tanpa warning, tetapi `flutter test` masih terdapat error/timeout pada pengujian unit `StatsNotifier` dan widget test. |

---

## 3. Ringkasan Perbaikan Teknis

Beberapa penyesuaian yang dilakukan pada kode hasil generat AI agar sesuai dengan *best practices*:

1. **Dependency Injection pada Notifier**:  
   Menambahkan opsional parameter `Random` pada konstruktor `StatsNotifier` agar perilaku acak (30% error) dapat di-*override* menggunakan `FakeRandom` saat pembuatan unit test.
2. **Pembersihan Exception Message**:  
   Merapikan tampilan error pada UI dengan mengeliminasi prefiks `Exception: ` agar pesan kesalahan lebih ramah pengguna (*user-friendly*).
3. **Pemanfaatan `ref.invalidate`**:  
   Memastikan tombol "Coba Lagi" menggunakan `ref.invalidate(statsProvider)` untuk melakukan reset state secara bersih dan memicu kembali method `build()` pada notifier.

---

# Refactoring dan testing

Refactoring Challenge

Lakukan refactoring berikut pada aplikasi ToDo Anda, lalu commit dengan pesan yang jelas:

   1. Pisahkan widget bar ToDo menjadi TodoTile tersendiri agar build lebih pendek dan mudah diuji.
   2. Ekstrak logika filter (misal tampilkan hanya yang belum selesai) menjadi Provider turunan yang membaca todoListProvider.
   3. Integrasikan aplikasi ToDo dengan GoRouter: / untuk daftar dan /stats untuk halaman statistik, tambahkan NavigationBar untuk berpindah.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

| No | Kriteria Verifikasi | Status | Catatan Verifikasi |
|:---:|---|:---:|---|
| 1 | **Navigasi GoRouter Bekerja** | ✅ Pass | Perpindahan antarhalaman (`/` dan `/stats`), fitur *back*, serta akses *path* secara langsung bekerja sesuai ekspektasi tanpa memuat ulang (*reload*) seluruh *app state*. |
| 2 | **`ProviderScope` di Root Aplikasi** | ✅ Pass | `ProviderScope` membungkus `MyApp()` pada `main.dart`. State daftar ToDo tetap bertahan (*persistent*) saat pengguna berpindah tab/halaman. |
| 3 | **UI `AsyncValue` Komprehensif** | ✅ Pass | Halaman statistik (`StatsPage`) menangani ketiga kondisi `AsyncValue` (`loading`, `error` dengan tombol *retry*, dan `data` *success*) menggunakan method `.when()`. |
| 4 | **Analisis Kode & Testing Clear** | ✅ Pass | Eksekusi `flutter analyze` menghasilkan **0 issue/warning**, dan seluruh pengujian otomatis pada `flutter test` **lulus 100%**. |

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/92ab8356f7d650b00d6d2fa06faf109c4691ea63/minggu-3/WhatsApp%20Image%202026-09-10%20at%2013.48.38(1).jpeg)

