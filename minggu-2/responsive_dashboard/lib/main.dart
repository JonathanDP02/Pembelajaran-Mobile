import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DashboardApp());

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDark: isDark,
        onDarkChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.isDark,
    required this.onDarkChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          Row(
            children: [
              // 1. ExcludeSemantics: Sembunyikan ikon dekoratif agar tidak dibaca ganda
              ExcludeSemantics(
                child: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              ),
              const SizedBox(width: 4),
              // 2. Semantics: Memberikan label, status toggled, dan petunjuk aksi pada saklar
              Semantics(
                label: 'Saklar Mode Gelap',
                hint: isDark
                    ? 'Ketuk dua kali untuk beralih ke mode terang'
                    : 'Ketuk dua kali untuk beralih ke mode gelap',
                toggled: isDark,
                child: CupertinoSwitch(
                  value: isDark,
                  onChanged: onDarkChanged,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 960
              ? 4
              : constraints.maxWidth >= 600
                  ? 2
                  : 1;

          final childAspectRatio = constraints.maxWidth >= 960
              ? 2.8
              : constraints.maxWidth >= 600
                  ? 2.2
                  : 1.7;

          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            children: const [
              DashboardCard(
                title: 'Total Students',
                value: '1,248',
                semanticValue: '1248 siswa',
              ),
              DashboardCard(
                title: 'Present Today',
                value: '982',
                semanticValue: '982 siswa hadir hari ini',
              ),
              DashboardCard(
                title: 'Absent',
                value: '143',
                semanticValue: '143 siswa tidak hadir',
              ),
              DashboardCard(
                title: 'Avg. Score',
                value: '87.4%',
                semanticValue: '87 koma 4 persen',
              ),
              DashboardCard(
                title: 'Classrooms',
                value: '18',
                semanticValue: '18 ruang kelas',
              ),
              DashboardCard(
                title: 'Teachers',
                value: '42',
                semanticValue: '42 guru',
              ),
              DashboardCard(
                title: 'Assignments',
                value: '64',
                semanticValue: '64 tugas',
              ),
              DashboardCard(
                title: 'Completed',
                value: '51',
                semanticValue: '51 selesai',
              ),
            ],
          );
        },
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.title,
    required this.value,
    this.semanticValue,
    super.key,
  });

  final String title;
  final String value;
  final String? semanticValue;

  @override
  Widget build(BuildContext context) {
    // 3. Semantics + MergeSemantics pada Kartu:
    // Menggabungkan teks judul dan nilai agar dibaca sebagai satu kesatuan kalimat.
    return Semantics(
      container: true,
      label: 'Statistik $title',
      value: semanticValue ?? value,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Text(title),
              ),
              // 4. semanticsLabel pada Text:
              // Mencegah bacaan simbol/angka yang kaku (misal '%' dibaca 'persen')
              Text(
                value,
                semanticsLabel: semanticValue ?? value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}