import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<List<String>> {
  final Random _random;
  final Duration _delay;

  StatsNotifier({Random? random, Duration? delay})
      : _random = random ?? Random(),
        _delay = delay ?? const Duration(seconds: 2);

  @override
  FutureOr<List<String>> build() async {
    await Future.delayed(_delay);
    // Simulasi 30% error rate
    if (_random.nextDouble() < 0.3) {
      throw Exception('Gagal memuat data statistik dari server');
    }
    return [
      'Total Pengguna: 1,250',
      'Tugas Selesai Hari Ini: 84%',
      'Rata-rata Waktu Penyelesaian: 25 menit',
    ];
  }
}

final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);