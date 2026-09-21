# week4_tugas

Bangun aplikasi daftar data dari REST API sebagai tugas minggu ini (kembangkan project codelab atau buat baru):

1. Ambil data dari API dummy (JSONPlaceholder /posts atau API publik lain tanpa key). Tampilkan ke UI melalui repository + Riverpod.
2. Terapkan Dio terpusat (base URL, timeout, interceptor logging) dan model fromJson aman null.
3. Tampilkan keempat state: loading, error (+ tombol retry), empty, success.
4. Tambahkan pagination dasar (infinite scroll, 10 item per halaman) dengan guard request ganda.
5. Sertakan minimal 2 test yang lulus (1 unit test model/error mapping + 1 test provider dengan repository palsu).
6. Kerjakan bagian AI Challenge dan dokumentasikan prompt, hasil AI, perbaikan, serta alasan keputusan teknis Anda di docs/.
7. Push ke repository portfolio pada folder 04-week-4-networking-rest-api/ dengan struktur lib/, test/, docs/, README.md, dan screenshots/. README menjelaskan tujuan, fitur utama, stack teknologi, cara menjalankan, dan hasil yang dicapai.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/4e8809f422c646fe0cf4077ef0eeccc52e002f30/minggu-4/week4_api/refactoring%20chellenge.png)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/4e8809f422c646fe0cf4077ef0eeccc52e002f30/minggu-4/week4_api/refactoring%20chellenge.png)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/4e8809f422c646fe0cf4077ef0eeccc52e002f30/minggu-4/week4_api/refactoring%20chellenge.png)

# Refleksi

1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?

Jawaban:
- Alasan: Melanggar pemisahan lapisan arsitektur (separation of concerns); UI harus fokus pada tampilan, bukan logika jaringan.
- Dampak jika dilanggar: Kode menjadi tightly coupled (sulit diubah jika API/library berubah), sangat sulit diuji (hard to unit test), dan duplikasi kode penanganan error di banyak tempat.

2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (_page/_limit)?

Jawaban:
- Client-side cukup: Ketika total data keseluruhan dari server sangat sedikit (jumlah kecil dan tetap).
- Server-side wajib (_page/_limit): Ketika dataset berukuran besar atau bertambah terus untuk menghemat memori, bandwidth, dan mempercepat waktu muat awal (initial load).

3. Bagaimana exception repository berubah menjadi AsyncError tanpa try/catch di setiap widget? Kapan try/catch eksplisit tetap dibutuhkan?

Jawaban:
- Otomatis menjadi AsyncError: Melalui fungsi pembantu AsyncValue.guard() di dalam Notifier/Provider Riverpod yang secara otomatis menangkap exception dan membungkusnya ke AsyncValue.error.
- Try/catch eksplisit tetap dibutuhkan: Saat melakukan aksi mutasi data khusus (seperti form submit/POST/PUT) yang memerlukan penanganan atau rollback state lokal secara manual di tingkat UI/Method.

4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?

Jawaban:
- Struktur Dependensi & Konfigurasi: Memperbaiki konflik duplikasi kunci pada pubspec.yaml (flutter_lints) serta melengkapi impor package dio dan path file yang terlewat pada Provider.

