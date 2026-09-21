import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/post.dart';

class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({super.key, required this.postId, this.preloadedPost});

  final int postId;
  final Post? preloadedPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Jika post sudah ada dari list, langsung tampilkan. Jika dibuka langsung via URL/Router, bisa ambil via repository/provider.
    final post = preloadedPost;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Post #$postId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: post != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.body,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : const Center(
                child: Text('Data detail post tidak ditemukan atau sedang dimuat.'),
              ),
      ),
    );
  }
}