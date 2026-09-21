import 'package:dio/dio.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    ),
  );

  // Interceptor untuk logging sederhana
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        print('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
        return handler.next(e);
      },
    ),
  );

  return dio;
}