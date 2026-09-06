# minggu-2

# Tugas utama

Kembangkan dashboard menjadi halaman Academic Overview dengan ketentuan:

Memiliki header profil dan minimal empat kartu informasi.
Menggunakan Row, Column, Expanded, dan Container.
Menampilkan satu kolom pada layar sempit dan dua kolom pada layar lebar.
Menyediakan light theme dan dark theme yang tetap terbaca, dengan toggle tema (misal CupertinoSwitch atau Switch.adaptive).
Memiliki label aksesibilitas untuk informasi atau tombol penting.
Menyertakan screenshot layar sempit dan lebar pada folder screenshots/.

# AI Prompt Challenge

1. Prompt desain:

Jawaban:

Versi GridView

        Responsif: Praktis untuk kartu-kartu yang ukurannya seragam. Namun, sulit digabung dengan komponen lain (seperti Header Profil) tanpa konfigurasi rumit.

        Aksesibilitas: Readout screen reader mengikuti indeks sel grid, yang terkadang membingungkan jika berpindah baris.

    Versi LayoutBuilder + Column (Dipilih)

        Responsif: Sangat fleksibel untuk gabungan Header + Kartu. Kontrol penuh via breakpoint (constraints.maxWidth).

        Aksesibilitas: Alur pembacaan screen reader mengalir alami dari atas ke bawah mengikuti hirarki UI.

Kesimpulan: LayoutBuilder + Column lebih unggul untuk tata letak bervariasi karena lebih fleksibel dan ramah aksesibilitas.

2. Prompt penguatan konsep:

Expanded berfungsi memaksa anak widget mengambil sisa ruang yang tersedia di dalam widget pembatas seperti Row atau Column.

Expanded justru akan menyebabkan error atau overflow jika diletakkan di dalam konteks ruang dengan lebar tidak terbatas (unbounded width). Contohnya adalah ketika Row berada di dalam widget yang bisa di-scroll secara horizontal seperti SingleChildScrollView(scrollDirection: Axis.horizontal). Pada kondisi ini, Row tidak memiliki batas lebar akhir, sehingga Expanded bingung menghitung berapa "sisa ruang" yang harus diambil.

Contoh Kode Gagal (Error / Crash):

// ERROR: Unbounded Width Constraints
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      // Memicu error "RenderFlex children have non-zero flex but incoming width constraints are unbounded"
      Expanded(
        child: Text('Teks ini sangat panjang dan akan pemicu error'),
      ),
    ],
  ),
)

Contoh Kode Perbaikan:
Jika memang membutuhkan scroll horizontal, lepas widget Expanded dan biarkan anak widget menentukan ukurannya sendiri, atau gunakan SizedBox / Container dengan lebar pasti.

// PERBAIKAN: Menggunakan SizedBox untuk lebar pasti di dalam scroll horizontal
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      SizedBox(
        width: 300, // Menentukan lebar pasti
        child: Text('Teks ini aman di dalam scroll horizontal'),
      ),
    ],
  ),
)

3. Verification prompt:

Hasil Self-Audit pada Screen Sangat Kecil (< 320px):

Meskipun logika LayoutBuilder sudah berpindah ke 1 kolom pada layar sempit, masih ada 2 potensi edge case (overflow) jika dijalankan pada layar ekstrem di bawah 320px (seperti HP fitur lama, layar jam tangan pintar, atau mode split-screen sempit):

    Ukuran Font & Teks Panjang (Text Overflow)

        Potensi Masalah: Jika nilai angka pada kartu terlalu besar (misal: "123,456,789") atau nama judul kartu terlalu panjang, teks bisa menabrak batas kartu dan memicu Right Overflowed by X pixels.

        Solusi: Tambahkan properti overflow: TextOverflow.ellipsis dan maxLines: 1 pada widget Text, atau bungkus teks dengan FittedBox agar ukuran font mengecil secara otomatis mengikuti ruang kartu.

    Padding & Spasial Kaku (Fixed Heights & Padding)

        Potensi Masalah: Penggunaan SizedBox(height: ...) atau Padding dengan nilai yang terlalu besar dan tetap (fixed) bisa menyebabkan Bottom Overflowed jika tinggi layar juga sangat terbatas.

        Solusi: Bungkus seluruh bodi dashboard dengan SingleChildScrollView dan gunakan spasi yang dinamis.

# Refactoring challenge

Setelah tugas utama berjalan, rapikan kode Anda:

1. Ekstrak kartu informasi menjadi widget reusable (misal InfoCard) yang menerima title dan value, sehingga tidak ada duplikasi widget.

2. Ganti warna dan ukuran yang di-hardcode dengan Theme.of(context) agar mengikuti tema terang/gelap secara otomatis.

3. Pindahkan breakpoint ke satu konstanta bernama (misal const kWideBreakpoint = 700;) agar hanya didefinisikan satu kali.

4. Jalankan flutter analyze dan pastikan tidak ada error maupun warning baru.

