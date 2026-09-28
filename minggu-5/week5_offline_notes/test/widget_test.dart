// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week5_offline_notes/main.dart';

void main() {
  testWidgets('Smoke test render MyApp', (WidgetTester tester) async {
    // Bungkus MyApp dengan ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verifikasi bahwa widget berhasil ter-render tanpa error
    expect(find.byType(MyApp), findsOneWidget);
  });
}