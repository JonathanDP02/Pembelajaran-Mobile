# Git Review Checklist

## Revisi pesan commit

| Pesan lama | Usulan pesan konvensional | Alasan |
|---|---|---|
| `praktikum1` | `feat(campus-notify): tambahkan aplikasi notifikasi kampus` | Menyebutkan perubahan utama dan area aplikasi; pesan lama tidak menjelaskan isi commit. |
| `Add files via upload` | `docs(campus-notify): tambahkan gambar dokumentasi` | Menjelaskan bahwa berkas yang ditambahkan adalah aset dokumentasi Campus Notify. |
| `Implement new feature for user authentication and improve error handling` | `feat(auth): tambahkan autentikasi dan penanganan error` | Memakai tipe perubahan dan scope, serta merangkum perubahan tanpa kalimat yang terlalu panjang. |

Pesan-pesan lama di atas hanya dicatat sebagai latihan; riwayat Git yang sudah
ada tidak ditulis ulang.

## Checklist sebelum review

- [ ] Perubahan dibuat pada branch fitur dari `develop`, bukan langsung di `main`.
- [ ] `git status` hanya menampilkan perubahan yang memang akan direview.
- [ ] `git add -p` dipakai untuk memilih satu perubahan logis per commit.
- [ ] Pesan commit mengikuti format `<type>(<scope>): <ringkasan>`.
- [ ] Tes dan analisis yang relevan berhasil sebelum branch didorong.
- [ ] Pull request ditujukan ke `develop`.
