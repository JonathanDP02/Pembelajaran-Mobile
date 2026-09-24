import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prefs.dart';
import '../data/repositories/note_repository.dart';

final prefsRepositoryProvider = Provider((ref) => PrefsRepository());
final darkModeProvider =
    AsyncNotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);

class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() =>
      ref.watch(prefsRepositoryProvider).getDarkMode();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setDarkMode(next);
      return next;
    });
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final isForceOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          // Pengaturan Mode Gelap (SharedPreferences)
          darkModeAsync.when(
            data: (isDark) => SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Aktifkan tema gelap aplikasi'),
              value: isDark,
              onChanged: (_) {
                ref.read(darkModeProvider.notifier).toggle();
              },
            ),
            loading: () => const ListTile(
              title: Text('Mode Gelap'),
              trailing: CircularProgressIndicator(),
            ),
            error: (err, stack) => ListTile(
              title: const Text('Mode Gelap'),
              subtitle: Text('Error: $err'),
            ),
          ),
          const Divider(),
          // Toggle Force Offline untuk Demo & Pengujian Praktikum
          SwitchListTile(
            title: const Text('Simulasi Force Offline'),
            subtitle: const Text('Memutus koneksi jaringan untuk testing sync'),
            secondary: Icon(
              isForceOffline ? Icons.wifi_off : Icons.wifi,
              color: isForceOffline ? Colors.red : Colors.green,
            ),
            value: isForceOffline,
            onChanged: (value) {
              ref.read(forceOfflineProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }
}