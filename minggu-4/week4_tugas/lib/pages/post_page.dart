import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_provider.dart';
import '../utils/network_errors.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(postProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Post (Pagination & Riverpod)')),
      body: postState.posts.when(
        // 1. STATE LOADING (Pertama kali dibuka)
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // 2. STATE ERROR (+ Tombol Retry)
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  friendlyErrorMessage(error),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => ref.read(postProvider.notifier).loadFirstPage(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),

        // 3 & 4. STATE SUCCESS & EMPTY
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum ada data post.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.read(postProvider.notifier).loadFirstPage(),
                    child: const Text('Muat Ulang'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: posts.length + (postState.hasMore ? 1 : 1),
            itemBuilder: (context, index) {
              if (index < posts.length) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(post.id.toString())),
                    title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                );
              } else {
                // Indikator di bagian bawah list (Loading more / Akhir data)
                if (postState.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Semua data telah ditampilkan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}