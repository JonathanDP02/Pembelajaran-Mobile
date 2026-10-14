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