import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week5_offline_notes/pages/note_page.dart';
import 'pages/note_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(
    // Wajib membungkus seluruh aplikasi dengan ProviderScope agar Riverpod berjalan
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memantau state dark mode dari DarkModeNotifier (Praktikum 1)
    final darkModeAsync = ref.watch(darkModeProvider);

    return MaterialApp(
      title: 'Offline Notes',
      debugShowCheckedModeBanner: false,
      // Mengatur tema terang dan gelap
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: darkModeAsync.when(
        data: (isDark) => isDark ? ThemeMode.dark : ThemeMode.light,
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      ),
      home: const MainNavigationPage(),
    );
  }
}

// Halaman navigasi sederhana untuk berpindah antara NotesPage dan SettingsPage
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

final List<Widget> _pages = [
  const NotesPage(),
  const SettingsPage(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note_outlined),
            selectedIcon: Icon(Icons.note),
            label: 'Catatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}