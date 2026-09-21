import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/comment_provider.dart'; // Sesuaikan path import

class CommentPage extends ConsumerWidget {
  const CommentPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memanggil provider family dengan menyertakan postId
    final commentsAsync = ref.watch(commentListProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar untuk Post #$postId'),
      ),
      body: commentsAsync.when(
        data: (comments) {
          if (comments.isEmpty) {
            return const Center(child: Text('Belum ada komentar.'));
          }
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(comment.id.toString()),
                ),
                title: Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.email, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(comment.body),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  friendlyErrorMessage(error),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  // Memanggil fungsi refresh pada notifier
                  onPressed: () => ref.read(commentListProvider(postId).notifier).refresh(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}