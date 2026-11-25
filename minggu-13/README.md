# Minggu 13 — CI/CD Flutter dengan GitHub Actions

Jobsheet ini membuat aplikasi Flutter sederhana dan pipeline CI yang memeriksa
format, analisis statis, test, lalu membangun APK dan AAB Android. Workflow
berada di `.github/workflows/flutter-ci.yml` pada root repository (lokasi yang
disyaratkan GitHub Actions), sedangkan seluruh perintah Flutter dijalankan dari
folder `minggu-13`.

## Alur CI/CD

1. Push ke `main` atau pull request yang menargetkan `main` memicu workflow
   apabila perubahan menyentuh `minggu-13/**` atau file workflow. Workflow juga
   dapat dijalankan manual dengan `workflow_dispatch`.
2. Runner Ubuntu mengambil source code dan menyiapkan Flutter stable 3.47.2.
3. Pipeline mengambil dependency, memeriksa format dan analisis, lalu
   menjalankan test dengan coverage.
4. Jika semua pemeriksaan lulus, pipeline membangun APK release dan AAB serta
   mengunggah keduanya sebagai artefak selama tujuh hari.

CI mengintegrasikan perubahan secara otomatis dengan pemeriksaan berulang.
Continuous delivery/deployment mengotomatiskan penyiapan atau pengiriman rilis.
Workflow ini adalah CI ditambah build artefak; workflow ini **tidak**
mempublikasikan aplikasi ke Google Play.

## Menjalankan pemeriksaan lokal

Jalankan dari root repository:

```powershell
cd .\minggu-13
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test --coverage
flutter build apk --release
flutter build appbundle --release
```

File yang dihasilkan:

- APK: `build/app/outputs/flutter-apk/app-release.apk` — untuk instalasi/uji
  internal.
- AAB: `build/app/outputs/bundle/release/app-release.aab` — format distribusi
  Google Play.

## Versi dan keamanan

Versi awal aplikasi pada `pubspec.yaml` adalah `1.0.0+1`: `1.0.0` adalah versi
aplikasi dan `1` adalah build number. Versi berikutnya yang direncanakan untuk
rilis perbaikan adalah `1.0.1+2`; versi dan build number di `pubspec.yaml`
perlu diperbarui saat rilis tersebut benar-benar disiapkan. Tag seperti
`v1.0.1` sebaiknya dibuat pada commit yang sudah lulus workflow.

Workflow hanya memiliki permission `contents: read`. Repository ini tidak
memasukkan token, password, atau keystore. `--dart-define` tidak cocok untuk
menyimpan secret karena nilainya dapat diekstrak dari aplikasi klien. Jika
kelak menambahkan signing, simpan material sensitif di GitHub Actions Secrets
dan gunakan hanya pada workflow rilis tepercaya; jangan berikan akses signing
ke pull request dari fork. Signing, konfigurasi aplikasi, izin, dan pengujian
perangkat masih perlu ditinjau sebelum publikasi.

## Hasil dan bukti

| Pemeriksaan | Hasil |
|---|---|
| Flutter SDK lokal | Flutter 3.47.2 stable; Dart 3.13.2 |
| Format | Lulus — `dart format --output=none --set-exit-if-changed .` |
| Analisis statis | Lulus — `flutter analyze --fatal-infos` |
| Test | Lulus — `flutter test --coverage` |
| APK release | Lulus; `build/app/outputs/flutter-apk/app-release.apk` (44,103,716 byte) |
| AAB release | Lulus; `build/app/outputs/bundle/release/app-release.aab` (44,257,482 byte) |
| GitHub Actions | Belum ada run jarak jauh; workflow perlu didorong ke branch `main` atau diajukan melalui pull request ke `main`. |

Pemeriksaan lokal memakai perintah yang sama dengan workflow; file APK/AAB
lokal bukan artefak yang diunggah GitHub Actions. Run URL, status Actions,
unduhan artefak dari tab Actions, dan commit yang menghasilkan run baru hanya
dapat dicatat setelah perubahan ini dikomit lalu workflow dijalankan di GitHub.
Saat ini branch aktif adalah `feat/notes-validation`, sehingga push pada branch
tersebut tidak memenuhi trigger push ke `main`. Belum ada commit untuk
perubahan minggu-13; `HEAD` saat pengerjaan (`950d941`) adalah commit minggu-9
sebelum perubahan ini dan bukan bukti commit tugas.

## Pertanyaan jobsheet dan jawaban

### Tugas

1. **Workflow CI:** dibuat di `.github/workflows/flutter-ci.yml`, memeriksa
   format, analisis, dan test untuk aplikasi `minggu-13`.
2. **APK/AAB:** dibangun sebagai release dan diunggah bersama sebagai artefak
   `android-builds` dengan masa simpan tujuh hari.
3. **Run melalui pull request atau push dan sertakan bukti serta commit:**
   pemeriksaan dan kedua build telah diverifikasi lokal. Run GitHub Actions
   belum dapat dibuktikan karena perubahan belum dikirim pada branch `main`
   atau melalui pull request ke `main`; tidak ada run ID atau commit baru yang
   dapat diklaim. Setelah push/PR, periksa semua step pada tab **Actions**,
   unduh `android-builds`, lalu catat URL run dan SHA commit di bagian hasil
   tabel ini.
4. **Versi berikutnya, pemeriksaan, dan risiko:** versi perbaikan yang
   direncanakan `1.0.1+2`; pemeriksaan format, analyze, test, dan build
   dijelaskan di atas. Risiko yang tersisa meliputi signing, konfigurasi/izin
   aplikasi, serta validasi di perangkat dan review manual sebelum rilis.

### Refleksi

- **Masalah apa yang ditemukan otomatis sebelum perubahan di-merge?**
  Tidak ada masalah pada pemeriksaan lokal kali ini: format, analisis, test,
  APK, dan AAB semuanya lulus. Jika terjadi, workflow akan menandai perubahan
  format, issue analisis Dart (termasuk info), kegagalan unit/widget test,
  atau kegagalan build APK/AAB sebagai job gagal sebelum merge.
- **Informasi apa yang dibutuhkan untuk menyelidiki build yang gagal?**
  URL dan nomor run, SHA commit/branch atau pull request, nama step yang gagal
  beserta log lengkapnya, versi Flutter/Dart, hasil dependency resolution,
  serta ketersediaan file keluaran ketika langkah upload artefak gagal. Jangan
  membagikan nilai secret saat membagikan log.
- **Bagian mana yang masih perlu persetujuan atau pemeriksaan manual sebelum
  rilis?** Signing dan konfigurasi aplikasi, izin, pengujian di perangkat
  sasaran, peninjauan artefak, dan persetujuan rilis/publikasi. Build sukses
  saja bukan bukti aplikasi siap dipublikasikan.
