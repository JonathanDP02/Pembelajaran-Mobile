# pertemuan-5

# Simulasi offline yang deterministik

- Matikan Wi-Fi / aktifkan mode pesawat, buka kembali aplikasi: catatan tetap tampil, badge dirty tetap akurat.
- Nyalakan kembali koneksi, jalankan syncNotes: badge kembali ke 0.
- Tuliskan langkah dan hasil observasi Anda (screenshot sebelum/sesudah) ke folder screenshots/.

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/30d3792d4c77b76bf6e2be6bbe36e29f3fffa132/minggu-5/week5_offline_notes/WhatsApp%20Image%202026-09-28%20at%2021.34.38.jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/30d3792d4c77b76bf6e2be6bbe36e29f3fffa132/minggu-5/week5_offline_notes/WhatsApp%20Image%202026-09-28%20at%2021.34.37.jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/30d3792d4c77b76bf6e2be6bbe36e29f3fffa132/minggu-5/week5_offline_notes/WhatsApp%20Image%202026-09-28%20at%2021.34.37(1).jpeg)

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/30d3792d4c77b76bf6e2be6bbe36e29f3fffa132/minggu-5/week5_offline_notes/WhatsApp%20Image%202026-09-28%20at%2021.34.38(1).jpeg)

# AI Prompt Challenge

Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift
untuk dua kebutuhan ini. Requirements:
- Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream),
  type-safety, ukuran boilerplate, dan kemudahan testing.
- Beri rekomendasi final: mana untuk preferensi, mana untuk catatan,
  beserta alasannya dalam 1 tabel.
- Tunjukkan skema tabel/kotak untuk 1000+ catatan.
Jelaskan trade-off setiap pilihan.

---

## 📊 1. Perbandingan Media Penyimpanan (*Storage Options*)

Berikut adalah hasil perbandingan teknis antara empat opsi penyimpanan lokal pada Flutter:

| Kriteria | `SharedPreferences` | `Hive` | `sqflite` (SQLite) | `Drift` (Type-safe SQLite) |
| :--- | :--- | :--- | :--- | :--- |
| **Kompleksitas Query** | Sangat Rendah (Key-Value) | Rendah–Sedang (Filter/Map manual) | Tinggi (Raw SQL Query) | **Tinggi** (Fluent API / Type-safe SQL) |
| **Kebutuhan Relasi** | Tidak Ada | Tidak Ada (Perlu pengolahan manual) | Sangat Baik (Foreign Key, JOIN) | **Sangat Baik** (Foreign Key & JOIN via Dart API) |
| **Reaktivitas (Stream)** | Tidak Ada | Ada (`ValueListenable` / `Watch`) | Tidak Ada (Perlu *StreamController* manual) | **Sangat Baik** (Built-in `.watch()`) |
| **Type-Safety** | Sangat Rendah | Sedang (Perlu `TypeAdapter`) | Rendah (`Map<String, dynamic>`) | **Sangat Tinggi** (Code Generation) |
| **Ukuran Boilerplate** | Sangat Kecil | Sedang | Sedang | Besar (Membutuhkan `build_runner`) |
| **Kemudahan Testing** | Sangat Mudah | Sedang | Sedang (`sqflite_common_ffi`) | **Sangat Mudah** (Database *In-Memory*) |

---

## 🎯 2. Rekomendasi Final Storage

| Kebutuhan Data | Storage Terpilih | Alasan Utama |
| :--- | :--- | :--- |
| **Preferensi Tema** (*User Settings*) | **`SharedPreferences`** | Sederhana, *lightweight*, hanya menyimpan data skalar sederhana (seperti `isDarkMode`), dan tidak memerlukan query kompleks maupun relasi. |
| **1000+ Catatan** (*Notes Data*) | **`Drift`** *(atau `sqflite`)* | Memiliki performa query terstruktur yang baik, mendukung indexing untuk skalabilitas 1000+ data, serta menyediakan antrean sinkronisasi (*offline sync*). |

---

## 🗄️ 3. Skema Database untuk 1000+ Catatan (Offline-First Sync)

Untuk menangani 1000+ catatan dengan performa tinggi dan mendukung fitur sinkronisasi offline, skema database dilengkapi dengan *dirty flag*, timestamp, dan *index*.

### DDL / Skema SQL (`notes` Table)

```sql
CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    body TEXT NOT NULL DEFAULT '',
    updated_at INTEGER NOT NULL,  -- Unix timestamp (milliseconds)
    dirty INTEGER NOT NULL DEFAULT 1, -- 1: Perlu disinkronkan ke server, 0: Sudah tersinkron
    is_deleted INTEGER NOT NULL DEFAULT 0 -- Soft delete flag untuk pencatatan hapus offline
);

-- Index untuk mengoptimalkan query antrean sinkronisasi (dirty notes)
CREATE INDEX idx_notes_dirty ON notes(dirty);

-- Index untuk sorting catatan berdasarkan waktu perubahan terbaru
CREATE INDEX idx_notes_updated_at ON notes(updated_at DESC);

```

## ⚖️ Analisis Trade-Off Setiap Pilihan Storage

### 1. SharedPreferences
* **Keuntungan:**
  * Implementasi sangat cepat dan *lightweight*.
  * Tidak membutuhkan konfigurasi skema atau migrasi database.
  * Sangat efisien untuk menyimpan *key-value* sederhana (seperti `isDarkMode` atau `user_token`).
* **Kerugian / Trade-off:**
  * Tidak dirancang untuk data berstruktur atau koleksi (kumpulan objek/array).
  * Tidak memiliki dukungan pencarian (*querying*), pengurutan (*sorting*), atau relasi.
  * Risiko korupsi data tinggi jika dipaksa menyimpan JSON string berukuran besar.

---

### 2. Hive
* **Keuntungan:**
  * Performa *read/write* sangat tinggi (berbasis *NoSQL key-value* di dalam memori/disk).
  * Mendukung reaktivitas sederhana via `ValueListenableBuilder` atau `watch()`.
  * Mudah digunakan tanpa memerlukan sintaks SQL.
* **Kerugian / Trade-off:**
  * Query kompleks (seperti *full-text search* atau pengurutan berdasarkan beberapa kriteria) harus dilakukan secara manual di memori.
  * Tidak ada dukungan relasi (*Foreign Key* / *JOIN*) antar-tabel secara bawaan.
  * Perlu membuat `TypeAdapter` manual atau menggunakan *code generation* untuk setiap model data.

---

### 3. sqflite (SQLite)
* **Keuntungan:**
  * Murni menggunakan *Engine* SQLite standar (sangat stabil dan *portable*).
  * Fleksibel dalam mengeksekusi *raw SQL query*, *JOIN*, *Foreign Key*, dan *Indexing*.
  * Tanpa dependensi *code generation* (*build_runner*), sehingga proses *build* aplikasi lebih cepat.
* **Kerugian / Trade-off:**
  * Tidak *type-safe*: Menggunakan `Map<String, dynamic>` sehingga rawan kesalahan penulisan nama kolom (*typo*).
  * Tidak mendukung reaktivitas *Stream* secara bawaan (harus di-wrap manual menggunakan State Management/`StreamController`).
  * Membutuhkan penulisan *boilerplate code* tambahan untuk konversi objek Dart dari/ke SQL Map.

---

### 4. Drift (Type-Safe SQLite)
* **Keuntungan:**
  * **Type-Safe 100%:** Mencegah *runtime error* akibat kesalahan penulisan sintaks SQL atau nama kolom.
  * **Reaktif secara Bawaan:** Mendukung `.watch()` yang langsung mengembalikan `Stream` saat data di database berubah.
  * Sangat mempermudah pengujian (*Unit Testing*) karena mendukung database *In-Memory*.
  * Tetap memiliki semua keunggulan SQLite (Relasi, *Foreign Key*, *Indexing*, dan *Performance* untuk 1000+ data).
* **Kerugian / Trade-off:**
  * Ukuran *boilerplate code* di awal cukup besar.
  * Wajib menjalankan `flutter pub run build_runner build` setiap kali ada perubahan skema database.
  * *Learning curve* sedikit lebih tinggi dibanding `sqflite` biasa.

## ✅ 5. AI Verification Checklist & Audit Result

Proses verifikasi dan audit terhadap keluaran/rekomendasi yang dihasilkan oleh AI Assistant selama pengerjaan Codelab:

- [x] **1. Penempatan Koleksi Catatan di Storage**
  * **Status:** TERVERIFIKASI / DISETUJUI
  * **Temuan Audit:** AI secara tepat **MENOLAK** penggunaan `SharedPreferences` untuk menyimpan daftar/koleksi catatan. `SharedPreferences` sifatnya rapuh untuk data koleksi array JSON dan rentan terhadap korupsi data. AI merekomendasikan SQLite (`sqflite`/`Drift`) atau Hive.

- [x] **2. Dukungan Skema untuk Antrean Sync (Offline-First)**
  * **Status:** TERVERIFIKASI / DISETUJUI
  * **Temuan Audit:** Skema database yang dirancang AI tidak sekadar CRUD polos, melainkan sudah dilengkapi atribut pendukung *offline-first sync*:
    * `dirty`: Flag indikator status sinkronisasi lokal vs server (1 = butuh sync, 0 = synced).
    * `updated_at`: Timestamp perubahan data untuk resolusi konflik sinkronisasi.
    * `is_deleted`: Soft-delete flag untuk menangani penghapusan data saat kondisi offline.

- [x] **3. Klaim Reaktivitas "Real-Time"**
  * **Status:** TERVERIFIKASI DENGAN CATATAN
  * **Temuan Audit:** Klaim reaktivitas real-time terbukti valid dan *built-in* pada **`Drift`** (via `.watch()`) dan **`Hive`** (via `watch()` / `ValueListenable`). Namun untuk **`sqflite`**, klaim reaktivitas tidak bisa berjalan otomatis melainkan harus di-wrap secara manual menggunakan `StreamController` atau State Management (seperti Riverpod Notifier).

- [x] **4. Estimasi Ukuran Boilerplate & Instalasi**
  * **Status:** TERVERIFIKASI / ACCURATE
  * **Temuan Audit:** Estimasi AI mengenai kompleksitas *setup* terbukti masuk akal setelah dicoba langsung via `flutter pub add`:
    * `SharedPreferences`: Sangat cepat, tanpa konfigurasi.
    * `sqflite`: Cepat, hanya butuh berkas konfig SQLite/DB helper.
    * `Drift`: Membutuhkan *boilerplate* paling besar karena perlu menambahkan `drift_dev` dan `build_runner` serta mengompilasi kode (*code generation*).

---

### 📌 Ringkasan Keputusan Final
* **Preferensi Tema:** Menggunakan **`SharedPreferences`** (Sederhana, *lightweight*, cukup untuk menyimpan status `isDarkMode`).
* **Penyimpanan Catatan:** Menggunakan **`sqflite` / `Drift`** (Mendukung query terstruktur, indexing cepat untuk 1000+ catatan, dan memiliki *dirty flag* untuk arsitektur *Offline-First Sync*).

# Refactoring, testing, dan error umum

1. Baris catatan diekstrak menjadi NoteTile dengan badge dirty.
2. Cache posts dan syncNotes dipindahkan ke lib/data/sync.dart.
3. Halaman detail NoteDetailPage membaca ulang catatan dari repository lokal melalui provider family, bukan memakai object dari state halaman list.
4. Routing didefinisikan dengan GoRouter: /, /note/:id, dan /settings.

# Testing
test/note_test.dart menguji:
- Note.fromMap() aman ketika field map hilang;
- flag dirty bertahan setelah serialisasi dan deserialisasi;
- provider berhasil mengambil data dari FakeNoteRepository tanpa SQLite.

test/widget_test.dart menguji badge Belum tersinkron pada NoteTile.

hasil akhir:

![image alt](https://github.com/JonathanDP02/Pembelajaran-Mobile/blob/30d3792d4c77b76bf6e2be6bbe36e29f3fffa132/minggu-5/week5_offline_notes/WhatsApp%20Image%202026-09-28%20at%2021.34.38(1).jpeg)