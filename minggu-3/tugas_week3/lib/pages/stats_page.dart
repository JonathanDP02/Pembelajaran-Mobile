import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugas_week3/providers/stats_provider.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Statistik')),
      body: statsAsync.when(
        // 1. State Loading
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        // 2. State Error
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Terjadi Kesalahan: $err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(statsProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        // 3. State Success (Data)
        data: (stats) => ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(stats[index]),
          ),
        ),
      ),
    );
  }
}