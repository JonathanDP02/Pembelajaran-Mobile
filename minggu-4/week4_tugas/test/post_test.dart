import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week4_tugas/models/post.dart';
import 'package:week4_tugas/repositories/post_repository.dart';
import 'package:week4_tugas/providers/post_provider.dart';
import 'package:week4_tugas/utils/network_errors.dart';

// Repository Palsu untuk Mock Testing tanpa Internet
class FakePostRepository extends PostRepository {
  FakePostRepository({this.items, this.throwError = false}) : super(Dio());
  final List<Post>? items;
  final bool throwError;

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async {
    if (throwError) {
      throw DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.connectionError,
      );
    }
    return items ?? [];
  }
}

void main() {
  // Test 1: Unit Test Model & Safe-Null Parsing
  test('fromJson aman terhadap field JSON yang hilang/null', () {
    final post = Post.fromJson({'id': 5});
    expect(post.id, 5);
    expect(post.userId, 0);
    expect(post.title, '');
    expect(post.body, '');
  });

  // Test 2: Unit Test Mapping Error Jaringan
  test('friendlyErrorMessage memetakan connection error dengan benar', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.connectionError,
    );
    expect(friendlyErrorMessage(err), contains('terhubung'));
  });

  // Test 3: Provider Test Sukses dengan Repository Palsu
  test('PostNotifier sukses memuat data dari repository palsu', () async {
    final fakeRepo = FakePostRepository(
      items: [
        const Post(userId: 1, id: 1, title: 'Title 1', body: 'Body 1'),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    // Tunggu state pertama selesai dimuat
    await container.read(postProvider.notifier).loadFirstPage();

    final state = container.read(postProvider);
    expect(state.posts.hasValue, true);
    expect(state.posts.value?.length, 1);
    expect(state.posts.value?.first.title, 'Title 1');
  });
}