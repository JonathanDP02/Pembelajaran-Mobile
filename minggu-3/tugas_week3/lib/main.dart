import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugas_week3/router/app_router.dart';

void main() {
  runApp(
    // Wajib ada ProviderScope di paling luar
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ToDo App',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}