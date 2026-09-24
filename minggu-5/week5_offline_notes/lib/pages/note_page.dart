import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/note_repository.dart';
import '../data/local/note.dart';

// Provider untuk instance NoteRepository
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

// Notifier untuk mengelola state daftar catatan
final notesNotifierProvider =
    AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    return ref.watch(noteRepositoryProvider).fetchNotes();
  }

  /// Menambah catatan baru
  Future<void> addNote(String title, String body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(noteRepositoryProvider);
      await repo.addNote(title: title, body: body);
      return repo.fetchNotes();
    });
  }

  /// Menghapus catatan berdasarkan ID
  Future<void> deleteNote(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(noteRepositoryProvider);
      await repo.deleteNote(id);
      return repo.fetchNotes();
    });
  }

  /// Menjalankan sinkronisasi catatan kotor ke server
  Future<int> syncData() async {
    final repo = ref.read(noteRepositoryProvider);
    final count = await repo.syncNotes();
    
    // Refresh daftar catatan agar status dirty terbarui di UI
    ref.invalidateSelf();
    return count;
  }
}

// Provider turunan untuk menghitung jumlah catatan kotor (dirty)
final dirtyCountProvider = Provider<int>((ref) {
  final notesState = ref.watch(notesNotifierProvider);
  return notesState.maybeWhen(
    data: (notes) => notes.where((note) => note.dirty).length,
    orElse: () => 0,
  );
});

// --- Halaman utama NotesPage ---
class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  bool _isSyncing = false;

  Future<void> _handleSync() async {
    setState(() => _isSyncing = true);
    try {
      final count =
          await ref.read(notesNotifierProvider.notifier).syncData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count > 0
                  ? '$count catatan berhasil disinkronkan!'
                  : 'Semua catatan sudah tersinkron.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Catatan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  ref.read(notesNotifierProvider.notifier).addNote(
                        titleController.text.trim(),
                        bodyController.text.trim(),
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesNotifierProvider);
    final dirtyCount = ref.watch(dirtyCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          // Indikator Badge Catatan Dirty / Belum Sync
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: _isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.sync),
                  tooltip: 'Sinkronkan Catatan',
                  onPressed: _isSyncing ? null : _handleSync,
                ),
                if (dirtyCount > 0 && !_isSyncing)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$dirtyCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada catatan.\nTekan tombol + untuk menambah.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${note.body}\n${note.updatedAt.toLocal()}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status Badge (Dirty / Synced)
                    Chip(
                      labelStyle: const TextStyle(fontSize: 10),
                      padding: EdgeInsets.zero,
                      avatar: Icon(
                        note.dirty ? Icons.cloud_off : Icons.cloud_done,
                        size: 14,
                        color: note.dirty ? Colors.orange : Colors.green,
                      ),
                      label: Text(note.dirty ? 'Unsynced' : 'Synced'),
                      backgroundColor: note.dirty
                          ? Colors.orange.shade50
                          : Colors.green.shade50,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        if (note.id != null) {
                          ref
                              .read(notesNotifierProvider.notifier)
                              .deleteNote(note.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}