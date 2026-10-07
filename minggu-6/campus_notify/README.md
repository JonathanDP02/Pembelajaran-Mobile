# Pertemuan 6

# Praktikum 2

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/b3ad2791a75eb1752b435032423b60fb3a232e6d/minggu-6/campus_notify/WhatsApp%20Image%202026-10-07%20at%2013.22.29(2).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/b3ad2791a75eb1752b435032423b60fb3a232e6d/minggu-6/campus_notify/WhatsApp%20Image%202026-10-07%20at%2013.22.29(1).jpeg)

# Praktikum 3

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/b3ad2791a75eb1752b435032423b60fb3a232e6d/minggu-6/campus_notify/WhatsApp%20Image%202026-10-07%20at%2013.22.29.jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/b3ad2791a75eb1752b435032423b60fb3a232e6d/minggu-6/campus_notify/WhatsApp%20Image%202026-10-07%20at%2013.22.28.jpeg)

# Refactoring, testing, dan error umum

## AI Challenge: verifikasi FCM

Prompt, draf awal yang diperiksa, perbaikan manual, keputusan teknis, dan
prosedur uji lengkap ada di [docs/ai-challenge.md](docs/ai-challenge.md).

### Checklist validasi

| No. | Checklist | Status | Bukti/catatan |
| --- | --- | --- | --- |
| 1 | Access/refresh token disimpan dengan `flutter_secure_storage`, bukan SharedPreferences; token penuh tidak dicetak ke log atau screenshot. | ✅ Lulus | Token debug FCM pada aplikasi ditampilkan terpotong. Token FCM dikirim ke backend untuk registrasi perangkat. |
| 2 | Respons 401 memicu refresh maksimal satu kali dan request dicoba ulang dengan access token baru. | ✅ Lulus | Dicakup oleh unit test skenario refresh berhasil. |
| 3 | Jika refresh gagal atau retry tetap menerima 401, sesi dibersihkan dan pengguna diminta login kembali. | ✅ Lulus | Dicakup oleh unit test skenario refresh gagal dan retry yang tetap menerima 401. |
| 4 | Pesan foreground menampilkan banner lokal; saat diketuk, aplikasi membuka rute dari payload. | ✅ Lulus | Sudah diuji di perangkat Android. |
| 5 | Pesan background menampilkan banner sistem; saat diketuk, aplikasi membuka rute dari payload. | ✅ Lulus | Sudah diuji di perangkat Android. |
| 6 | Pesan saat aplikasi terminated membuka aplikasi ke rute dari payload. | ✅ Lulus | Sudah diuji di perangkat Android. |
| 7 | Topic digunakan untuk broadcast; pesan personal ditujukan ke token perangkat, bukan topic. | ✅ Lulus | Aplikasi subscribe ke topic `pengumuman-kampus`; tersedia fungsi subscribe/unsubscribe. |
| 8 | `flutter analyze` bersih dan semua test lulus. | ✅ Lulus | `flutter analyze`: tanpa masalah. `flutter test`: 8 test lulus. |

### Hasil uji tiga app state

Payload pengujian menggunakan `route: /pengumuman/3`.

| App state | Hasil aktual |
| --- | --- |
| Foreground | ✅ Berhasil — banner lokal muncul dan klik membuka `/pengumuman/3`. |
| Background | ✅ Berhasil — banner sistem muncul dan klik membuka `/pengumuman/3`. |
| Terminated | ✅ Berhasil — aplikasi terbuka melalui notifikasi dan menuju `/pengumuman/3`. |

Hasil uji runtime di atas dicatat berdasarkan konfirmasi bahwa seluruh skenario
sudah dijalankan dan berhasil.

## Refactoring dan pengujian

- Konstanta navigasi dan parser payload FCM terpusat di `lib/routes.dart`.
- Pesan error Dio yang ramah UI terpusat di `lib/data/api_errors.dart`.
- Unit test tanpa Firebase berada di `test/auth_push_test.dart`; pengujian
  widget validasi login berada di `test/widget_test.dart`.
- Jalankan pemeriksaan dengan `flutter analyze` dan `flutter test` dari folder
  `campus_notify`.
- Pemeriksaan terakhir: `flutter analyze` bersih dan seluruh 8 test lulus;
  hasil uji perangkat FCM dicatat pada checklist di atas.
