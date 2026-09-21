import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/paged_posts.dart';
import '../data/providers.dart';

class PagedPostPage extends ConsumerWidget {
  const PagedPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pagedPostsProvider);

    if (state.error != null && state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Posts Paged')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(friendlyErrorMessage(state.error!)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref
                    .read(pagedPostsProvider.notifier)
                    .loadFirstPage(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Posts Paged')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.8) {
            final currentState = ref.read(pagedPostsProvider);
            if (!currentState.isLoadingMore && currentState.hasMore) {
              ref.read(pagedPostsProvider.notifier).loadNextPage();
            }
          }
          return false;
        },
        child: ListView.builder(
          itemCount: state.items.length + 1,
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              if (!state.hasMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('Semua data termuat.')),
                );
              }
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final post = state.items[index];
            return ListTile(
              leading: CircleAvatar(child: Text(post.id.toString())),
              title: Text(post.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          },
        ),
      ),
    );
  }
}