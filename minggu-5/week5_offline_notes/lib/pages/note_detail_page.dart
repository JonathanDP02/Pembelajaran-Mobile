import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import 'note_page.dart';

final noteByIdProvider = FutureProvider.family<Note?, int>((ref, id) {
  return ref.watch(noteRepositoryProvider).fetchNotes().then((notes) {
    for (final note in notes) {
      if (note.id == id) return note;
    }
    return null;
  });
});

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({required this.noteId, super.key});

  final int noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(noteByIdProvider(noteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: note.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Terjadi kesalahan: $error')),
        data: (value) {
          if (value == null) {
            return const Center(child: Text('Catatan tidak ditemukan'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(value.body),
                if (value.dirty) ...[
                  const SizedBox(height: 16),
                  const Chip(label: Text('Belum tersinkron')),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}