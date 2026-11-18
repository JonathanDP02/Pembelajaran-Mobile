import 'package:campus_notify/features/notes/application/notes_provider.dart';
import 'package:campus_notify/features/notes/domain/note.dart';
import 'package:campus_notify/features/notes/presentation/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pencarian judul menampilkan hasil dan empty state', (
    tester,
  ) async {
    final notes = [
      Note(
        id: 1,
        title: 'Kegiatan hari ini',
        body: 'Briefing pagi',
        updatedAt: DateTime(2026, 9, 27),
      ),
      Note(
        id: 2,
        title: 'Tugas',
        body: 'Laporan praktikum',
        updatedAt: DateTime(2026, 9, 28),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notesProvider.overrideWith(
            (ref) async => (notes: notes, failure: null),
          ),
        ],
        child: const MaterialApp(home: NotesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tugas'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../screenshots/query-empty.png'),
    );

    final searchField = find.byKey(const ValueKey('notes-search-field'));
    await tester.enterText(searchField, 'kEGIATAN');
    await tester.pumpAndSettle();
    expect(find.text('Kegiatan hari ini'), findsOneWidget);
    expect(find.text('Tugas'), findsNothing);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../screenshots/query-match.png'),
    );

    await tester.enterText(searchField, 'Briefing');
    await tester.pumpAndSettle();
    expect(find.text('Tidak ada catatan yang cocok.'), findsOneWidget);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('../../screenshots/query-no-match.png'),
    );
  });
}
