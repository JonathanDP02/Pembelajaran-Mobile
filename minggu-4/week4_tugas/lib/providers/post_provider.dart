import 'package:dio/dio.dart';
import '../services/dio_client.dart'; // Sesuaikan path jika file createDio() berada di folder lain
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import 'package:week4_tugas/repositories/post_repository.dart';
import 'package:week4_tugas/services/dio_client.dart';

// Provider Dio & Repository Terpusat
final dioProvider = Provider<Dio>((ref) => createDio());

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(ref.watch(dioProvider)),
);

// State untuk menampung daftar Post beserta status pagination
class PostState {
  final AsyncValue<List<Post>> posts;
  final bool hasMore;
  final int page;
  final bool isLoadingMore;

  const PostState({
    required this.posts,
    this.hasMore = true,
    this.page = 1,
    this.isLoadingMore = false,
  });

  PostState copyWith({
    AsyncValue<List<Post>>? posts,
    bool? hasMore,
    int? page,
    bool? isLoadingMore,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PostNotifier extends StateNotifier<PostState> {
  PostNotifier(this._repository) : super(const PostState(posts: AsyncValue.loading())) {
    loadFirstPage();
  }

  final PostRepository _repository;
  static const int _limit = 10;

  // Memuat halaman pertama (State: Loading, Success, Error, Empty)
  Future<void> loadFirstPage() async {
    state = state.copyWith(posts: const AsyncValue.loading(), page: 1, hasMore: true);
    
    state = await AsyncValue.guard(() async {
      final newItems = await _repository.fetchPostsPage(page: 1, limit: _limit);
      state = state.copyWith(hasMore: newItems.length >= _limit);
      return newItems;
    }).then((value) => state.copyWith(posts: value));
  }

  // Memuat halaman berikutnya dengan guard mencegah double request
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    if (state.posts.isLoading || state.posts.hasError) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.page + 1;
      final newItems = await _repository.fetchPostsPage(page: nextPage, limit: _limit);

      final currentItems = state.posts.value ?? [];
      
      state = state.copyWith(
        posts: AsyncValue.data([...currentItems, ...newItems]),
        page: nextPage,
        hasMore: newItems.length >= _limit,
        isLoadingMore: false,
      );
    } catch (e, st) {
      // Jika load more gagal, pertahankan data lama tapi hentikan status loading more
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  return PostNotifier(ref.watch(postRepositoryProvider));
});