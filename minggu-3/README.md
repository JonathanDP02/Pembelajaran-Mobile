# minggu 3

# konsep navigasi dan GoRouter

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3c95aa3375aefa9eb75d2328ba3ec9dce5195d28/minggu-2/responsive_dashboard/WhatsApp%20Image%202026-09-06%20at%2021.25.13.jpeg)

# state management dengan riverpod

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3c95aa3375aefa9eb75d2328ba3ec9dce5195d28/minggu-2/responsive_dashboard/WhatsApp%20Image%202026-09-06%20at%2021.25.13.jpeg)

# AsyncValue: loading, error, success
# Praktikum 3 — Uji ketiga state

1. Salin kode di atas ke project ToDo Anda (atau project terpisah) dan jalankan. Amati tampilan loading selama 2 detik pertama.

2. Ubah build() sementara untuk melempar error: throw Exception('Gagal terhubung ke server');. Jalankan dan amati UI error beserta tombol Coba lagi.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3c95aa3375aefa9eb75d2328ba3ec9dce5195d28/minggu-2/responsive_dashboard/WhatsApp%20Image%202026-09-06%20at%2021.25.13.jpeg)

3. Tekan tombol Coba lagi, ref.invalidate membuat provider dijalankan ulang. Pulihkan kode, pastikan state success tampil.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/3c95aa3375aefa9eb75d2328ba3ec9dce5195d28/minggu-2/responsive_dashboard/WhatsApp%20Image%202026-09-06%20at%2021.25.13.jpeg)

4. Refleksikan: mengapa menampilkan ulang data lama (stale data) dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola itu penting?

jawab: 
- Menampilkan data lama (stale data) dengan indikator refresh jauh lebih baik daripada mengosongkan layar karena menjaga kenyamanan visual (user experience). Pengguna tidak terganggu oleh efek flicker atau layar kosong mendadak, serta aplikasi terasa lebih cepat dan responsif karena informasi masih bisa dibaca selagi data baru dimuat di latar belakang.

- Pola ini sangat penting diterapkan pada fitur pull-to-refresh (seperti feed media sosial atau katalog produk), pembaruan data berkala (real-time/polling), serta kondisi jaringan yang kurang stabil agar pengguna tetap memiliki konteks informasi.


## Getting Started


