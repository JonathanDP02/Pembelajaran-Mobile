import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../local/db.dart';
import '../local/note.dart';

// Provider untuk mengontrol status Force Offline secara global
final forceOfflineProvider = StateProvider<bool>((ref) => false);

// Provider untuk NoteRepository
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

class NoteRepository {
  NoteRepository({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  Future<List<Note>> fetchNotes() async {
    final db = await _openDb();
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    return rows.map(Note.fromMap).toList();
  }

  Future<Note> addNote({required String title, String body = ''}) async {
    final db = await _openDb();
    final note = Note(
      title: title,
      body: body,
      updatedAt: DateTime.now(),
      dirty: true,
    );
    final id = await db.insert('notes', note.toMap());
    return Note(
      id: id,
      title: note.title,
      body: note.body,
      updatedAt: note.updatedAt,
      dirty: true,
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await _openDb();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countDirty() async {
    final db = await _openDb();
    final rows = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM notes WHERE dirty = 1');
    return ((rows.first['c'] as num?)?.toInt() ?? 0);
  }

  Future<void> markAllSynced() async {
    final db = await _openDb();
    await db.update('notes', {'dirty': 0}, where: 'dirty = 1');
  }

  /// Fungsi Sinkronisasi Catatan Kotor (dirty) dengan penanganan forceOffline
  Future<int> syncNotes({bool forceOffline = false}) async {
    // Jika forceOffline bernilai true, simulasikan kegagalan jaringan
    if (forceOffline) {
      throw Exception('Gagal sinkronisasi: Mode Offline aktif.');
    }

    final dirtyCount = await countDirty();
    if (dirtyCount == 0) return 0;

    // Simulasi upload ke REST API (1 detik delay)
    await Future.delayed(const Duration(seconds: 1));
    await markAllSynced();
    return dirtyCount;
  }

  Future<List<Map<String, dynamic>>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts');
    return rows.map((row) {
      final payload = row['payload'] as String;
      return jsonDecode(payload) as Map<String, dynamic>;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> loadPostsCacheFirst() async {
    final cached = await readCachedPosts();
    _refreshPostsInBackground();
    return cached;
  }

  void _refreshPostsInBackground() async {
    // Implementasi fetch API background
  }
}