import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_todo/providers/stats_provider.dart';

class FakeRandom implements Random {
  final double value;
  FakeRandom(this.value);

  @override
  double nextDouble() => value;

  @override
  bool nextBool() => throw UnimplementedError();
  @override
  int nextInt(int max) => throw UnimplementedError();
}

void main() {
  group('StatsNotifier Unit Tests', () {
    test('Mengembalikan data sukses saat random >= 0.3', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(
              random: FakeRandom(0.5),
              delay: Duration.zero,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.listen(statsProvider, (_, _) {});

      final result = await container.read(statsProvider.future);

      expect(result.length, 3);
      expect(result.first, 'Total Pengguna: 1,250');
      expect(
        container.read(statsProvider),
        isA<AsyncData<List<String>>>(),
      );
    });

    test('Mengembalikan error saat random < 0.3', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(
              random: FakeRandom(0.1),
              delay: Duration.zero,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.listen(statsProvider, (_, _) {});

      await Future<void>.value();

      final state = container.read(statsProvider);
      expect(state, isA<AsyncError<List<String>>>());
    });
  });
}