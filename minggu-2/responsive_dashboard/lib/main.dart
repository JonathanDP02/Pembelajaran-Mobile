import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double kWideBreakpoint = 700.0;

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
      title: 'Academic Overview',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: AcademicOverviewPage(
        isDark: isDark,
        onDarkChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}

class AcademicOverviewPage extends StatelessWidget {
  const AcademicOverviewPage({
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
        title: const Text('Academic Overview'),
        actions: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              ),
              const SizedBox(width: 4),
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
          final isWide = constraints.maxWidth >= kWideBreakpoint;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileHeader(),
                const SizedBox(height: 20),
                Text(
                  'Ringkasan Akademik',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                if (isWide)
                  const Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'IPK Kumulatif',
                              value: '3.85',
                              semanticValue: '3 koma 85',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: InfoCard(
                              title: 'Total SKS',
                              value: '68 SKS',
                              semanticValue: '68 S K S',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              title: 'Kehadiran',
                              value: '95%',
                              semanticValue: '95 persen',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: InfoCard(
                              title: 'Tugas Selesai',
                              value: '12/12',
                              semanticValue: '12 dari 12 tugas selesai',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const Column(
                    children: [
                      InfoCard(
                        title: 'IPK Kumulatif',
                        value: '3.85',
                        semanticValue: '3 koma 85',
                      ),
                      SizedBox(height: 12),
                      InfoCard(
                        title: 'Total SKS',
                        value: '68 SKS',
                        semanticValue: '68 S K S',
                      ),
                      SizedBox(height: 12),
                      InfoCard(
                        title: 'Kehadiran',
                        value: '95%',
                        semanticValue: '95 persen',
                      ),
                      SizedBox(height: 12),
                      InfoCard(
                        title: 'Tugas Selesai',
                        value: '12/12',
                        semanticValue: '12 dari 12 tugas selesai',
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Header Profil Murid
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              'M',
              style: TextStyle(
                fontSize: 24,
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mahasiswa Teknik Informatika',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM: 244107020197 • Semester 5',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
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
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      label: 'Informasi $title',
      value: semanticValue ?? value,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                value,
                semanticsLabel: semanticValue ?? value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}