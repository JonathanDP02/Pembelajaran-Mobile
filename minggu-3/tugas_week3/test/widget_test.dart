import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_week3/main.dart';

void main() {
  testWidgets('Menambah tugas baru dan memperbarui UI', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Memastikan kondisi awal kosong
    expect(find.text('Belum ada tugas'), findsOneWidget);

    // Buka dialog penambahan tugas
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Memasukkan teks dan klik Tambah
    await tester.enterText(find.byType(TextField), 'Kerjakan PR minggu 3');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Memastikan item baru muncul di UI
    expect(find.text('Kerjakan PR minggu 3'), findsOneWidget);
  });
}