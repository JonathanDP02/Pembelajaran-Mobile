# campus_notify

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Praktikum 3: Payload, app state, dan topic

Kirim payload gabungan `notification` dan `data` ke topic `pengumuman-kampus`.
Contoh pesan untuk pengujian:

```json
{
  "message": {
    "topic": "pengumuman-kampus",
    "notification": {
      "title": "Jadwal kuliah berubah",
      "body": "Kelas Mobile pindah ke Ruang A2 jam 13.00"
    },
    "data": {
      "route": "/pengumuman/3",
      "id": "3"
    }
  }
}
```

Pastikan aplikasi telah diberi izin notifikasi dan pengguna sudah login sebelum
menguji navigasi. Jalankan setiap skenario menggunakan payload yang sama:

| State | Yang diharapkan | Cara uji |
| --- | --- | --- |
| Foreground | Banner lokal muncul; saat diketuk, aplikasi membuka `/pengumuman/3`. | Buka aplikasi, lalu kirim pesan dari Firebase Console atau backend. |
| Background | Banner sistem muncul; saat diketuk, aplikasi membuka rute dari payload. | Tekan Home, kirim pesan, lalu ketuk banner. |
| Terminated | Aplikasi terbuka ke rute dari payload melalui `getInitialMessage`. | Tutup aplikasi sepenuhnya, kirim pesan, lalu ketuk banner. |

Topic `pengumuman-kampus` digunakan untuk broadcast kepada kelompok pengguna.
Untuk pesan pribadi seperti nilai atau tagihan, kirim ke token perangkat, bukan
ke topic. Notifikasi dengan `notification` ditampilkan otomatis oleh sistem
saat aplikasi berada di background atau terminated; pesan hanya-data tidak
ditampilkan otomatis.
