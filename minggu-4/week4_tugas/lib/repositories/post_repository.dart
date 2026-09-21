import 'package:dio/dio.dart';
import '../models/post.dart';

class PostRepository {
  PostRepository(this._dio);
  final Dio _dio;

  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {
        '_page': page,
        '_limit': limit,
      },
    );

    final data = response.data as List;
    return data.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  }
}