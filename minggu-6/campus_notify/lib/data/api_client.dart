import 'package:dio/dio.dart';

import 'auth_repository.dart';
import 'token_store.dart';

Dio buildApiClient(
  TokenStore store,
  AuthRepository auth, {
  void Function()? onSessionExpired,
  HttpClientAdapter? httpClientAdapter,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example-campus-api.test'));
  if (httpClientAdapter != null) dio.httpClientAdapter = httpClientAdapter;
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await store.readAccess();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode != 401 ||
            error.requestOptions.extra['retriedAfterRefresh'] == true) {
          return handler.next(error);
        }

        final refresh = await store.readRefresh();
        if (refresh == null || refresh.isEmpty) {
          await store.clear();
          onSessionExpired?.call();
          return handler.next(error);
        }

        late final String renewed;
        try {
          renewed = await auth.refresh(refresh);
        } on Exception {
          await store.clear();
          onSessionExpired?.call();
          return handler.next(error);
        }

        await store.save(access: renewed, refresh: refresh);
        final retryOptions = error.requestOptions.copyWith(
          extra: {
            ...error.requestOptions.extra,
            'retriedAfterRefresh': true,
          },
          headers: {
            ...error.requestOptions.headers,
            'Authorization': 'Bearer $renewed',
          },
        );
        try {
          final retry = await dio.fetch(retryOptions);
          return handler.resolve(retry);
        } on DioException catch (retryError) {
          if (retryError.response?.statusCode == 401) {
            await store.clear();
            onSessionExpired?.call();
          }
          return handler.next(retryError);
        }
      },
    ),
  );
  return dio;
}
