import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<List<String>> {
  final Random _random;
  final Duration _delay;

  StatsNotifier({
    Random? random,
    this._delay = const Duration(seconds: 2),
  }) : _random = random ?? Random();

  @override
  Future<List<String>> build() async {
    return _fetchStats();
  }

  Future<List<String>> _fetchStats() async {
    if (_delay > Duration.zero) {
      await Future.delayed(_delay);
    }

    if (_random.nextDouble() < 0.3) {
      throw Exception('Gagal mengambil data statistik dari server.');
    }

    return const [
      'Total Pengguna: 1,250',
      'Penjualan Bulanan: \$4,500',
      'Tingkat Konversi: 12.8%',
    ];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStats());
  }
}

final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);