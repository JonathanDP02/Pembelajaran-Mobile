import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/paged_post_page.dart'; // Sesuaikan path import halaman utama Anda

void main() {
  runApp(
    // ProviderScope wajib membungkus root aplikasi agar state management Riverpod aktif
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 4 - REST API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      // Halaman utama aplikasi (bisa diganti ke CommentPage jika ingin langsung menguji komentar)
      home: const PagedPostPage(),
    );
  }
}