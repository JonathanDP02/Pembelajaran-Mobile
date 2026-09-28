import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'local/db.dart';
import 'repositories/note_repository.dart';

Future<void> cachePosts(List<Map<String, dynamic>> posts) async {
  final db = await openNotesDb();

  for (final post in posts) {
    await db.insert(
      'cached_posts',
      {
        'id': post['id'],
        'payload': jsonEncode(post),
        'cached_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<List<Map<String, dynamic>>> readCachedPosts() async {
  final db = await openNotesDb();
  final rows = await db.query('cached_posts', orderBy: 'cached_at DESC');

  return rows
      .map((row) => jsonDecode(row['payload'] as String) as Map<String, dynamic>)
      .toList();
}

Future<int> syncNotes(NoteRepository repo, {bool offline = false}) async {
  if (offline) {
    throw StateError('Sinkronisasi tidak tersedia saat mode offline aktif');
  }

  final dirtyCount = await repo.countDirty();

  if (dirtyCount == 0) return 0;

  await Future.delayed(const Duration(seconds: 1));

  await repo.markAllSynced();

  return dirtyCount;
}