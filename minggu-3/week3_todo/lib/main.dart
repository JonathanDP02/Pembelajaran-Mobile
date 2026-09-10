import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/product_page.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 3 - AsyncValue',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const ProductPage(),
    );
  }
}