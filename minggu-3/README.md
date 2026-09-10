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


## Getting Started


