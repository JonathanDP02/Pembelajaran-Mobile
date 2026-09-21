# PERRTEMUAN 4

# Uji tiga skenario error
1. Jalankan aplikasi dengan internet normal, amati loading lalu daftar 100 posts.

Jawaban:
![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3e72781144ac41aa8dc853ca2deec31bc2302691/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2012.48.28.jpeg)

2. Matikan internet (mode pesawat), tekan refresh, amati pesan ramah + tombol Coba lagi. Nyalakan kembali internet, tekan Coba lagi.

Jawaban:
![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3e72781144ac41aa8dc853ca2deec31bc2302691/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2012.48.28(1).jpeg)

3. Sementara ubah baseUrl menjadi URL salah, amati pesan error koneksi. Kembalikan setelah uji.

Jawaban:
![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3e72781144ac41aa8dc853ca2deec31bc2302691/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2012.48.28(3).jpeg)

Ubah home di main.dart menjadi PagedPostPage, jalankan, dan scroll sampai bawah. Amati: halaman 1 tampil dulu, indikator muncul, data bertambah tanpa reload penuh.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/34fbff8ea774416e8525201756f98dc03959c052/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2013.21.44.jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/34fbff8ea774416e8525201756f98dc03959c052/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2013.21.45.jpeg)

# AI prompt challenge

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/34fbff8ea774416e8525201756f98dc03959c052/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2013.21.45.jpeg)

## 🔍 Checklist Verifikasi & Audit Kualitas Kode

* [x] **1. Apakah UI memanggil Dio secara langsung atau lewat repository?**
  * **Status:** Lolos (Lewat Repository).
  * **Catatan:** UI sama sekali tidak pernah melakukan inisialisasi ataupun memanggil Dio secara langsung. Akses data dienkapsulasi penuh melalui `AsyncNotifierProvider` yang mengonsumsi `CommentRepository`.

* [x] **2. Apakah `fromJson` aman null, atau masih memakai cast langsung yang bisa crash?**
  * **Status:** Lolos (Aman Null / *Defensive Casting*).
  * **Catatan:** Method `fromJson` pada model `Comment` menggunakan teknik *safe-casting* (`(json['postId'] as num?)?.toInt() ?? 0` dan `as String? ?? ''`). Ini mencegah aplikasi mengalami *crash* total jika API mengembalikan data kosong, korup, atau tipe data yang tidak sesuai.

* [x] **3. Apakah semua tipe `DioExceptionType` dipetakan ke pesan pengguna?**
  * **Status:** Lolos.
  * **Catatan:** Fungsi `friendlyErrorMessage` berhasil memetakan seluruh varian utama error Dio dengan baik:
    * `connectionTimeout`, `sendTimeout`, `receiveTimeout` $\rightarrow$ Pesan kendala koneksi lambat/timeout.
    * `connectionError` $\rightarrow$ Pesan gangguan jaringan terputus.
    * `badResponse` $\rightarrow$ Ditangani spesifik berdasarkan *status code* (seperti HTTP `404` data tidak ditemukan dan HTTP `500` gangguan server).

* [x] **4. Apakah `baseUrl`/timeout terpusat di satu client, bukan tersebar di tiap method?**
  * **Status:** Lolos (Terpusat).
  * **Catatan:** Seluruh konfigurasi dasar seperti `baseUrl`, *header*, dan batas waktu (*timeout*) diatur secara terpusat di dalam fungsi pembantu `createDio()` serta disediakan melalui `dioProvider`, sehingga bersih dari duplikasi kode di dalam *repository*.

* [x] **5. Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path?**
  * **Status:** Lolos dengan Tambahan *Edge Case*.
  * **Catatan:** Selain menguji *happy path* dan skenario field JSON yang hilang (*incomplete JSON*), telah ditambahkan *edge case* mandiri untuk menguji ketahanan model terhadap tipe data yang tidak valid (misalnya field angka dikirim sebagai string kosong atau sebaliknya).

* [x] **6. Jalankan `flutter analyze` dan `flutter test`, apakah hasil AI lolos tanpa warning?**
  * **Status:** Lolos Tanpa *Warning*.
  * **Catatan:** Berdasarkan hasil eksekusi terminal, perintah `flutter analyze` menunjukkan kode bersih tanpa ada satupun *lint warning*, dan seluruh rangkaian *unit test* (`flutter test`) berhasil lulus (*passed*).

---

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/34fbff8ea774416e8525201756f98dc03959c052/minggu-4/week4_api/WhatsApp%20Image%202026-09-21%20at%2013.21.45.jpeg)







