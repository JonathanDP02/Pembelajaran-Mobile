import 'dart:typed_data';

import 'package:campus_notify/core/routes.dart';
import 'package:campus_notify/features/auth/application/auth_provider.dart';
import 'package:campus_notify/features/auth/data/api_client.dart';
import 'package:campus_notify/features/auth/data/api_errors.dart';
import 'package:campus_notify/features/auth/domain/auth_repository.dart';
import 'package:campus_notify/features/auth/domain/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('routeFromMessage handles empty and relative routes', () {
    expect(routeFromMessage({}), AppRoutes.home);
    expect(routeFromMessage({'route': ''}), AppRoutes.home);
    expect(routeFromMessage({'route': '  '}), AppRoutes.home);
    expect(
      routeFromMessage({'route': 'pengumuman/3'}),
      AppRoutes.announcementById('3'),
    );
    expect(
      routeFromMessage({'route': '/pengumuman/3'}),
      AppRoutes.announcementById('3'),
    );
    expect(routeFromMessage({'route': 3}), AppRoutes.home);
  });

  test('message payload includes the announcement id', () {
    const data = {'route': '/pengumuman/3', 'id': '3'};
    expect(data['id'], '3');
    expect(routeFromMessage(data), AppRoutes.announcementById('3'));
  });

  test('auth provider reads login state from stored access token', () async {
    final store = _FakeTokenStore(access: 'mock-access');
    final container = ProviderContainer(
      overrides: [tokenRepositoryProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);

    expect(await container.read(authStateProvider.future), isTrue);

    store.access = null;
    container.invalidate(authStateProvider);
    expect(await container.read(authStateProvider.future), isFalse);
  });

  test(
    '401 retries once and clears session if retry is unauthorized',
    () async {
      final store = _FakeTokenStore(
        access: 'old-access',
        refresh: 'refresh-token',
      );
      final auth = _SuccessfulRefreshRepository();
      final adapter = _ResponseSequenceAdapter([401, 401]);
      var expiredSessions = 0;
      final dio = buildApiClient(
        store,
        auth,
        onSessionExpired: () => expiredSessions++,
        httpClientAdapter: adapter,
      );

      await expectLater(dio.get('/private'), throwsA(isA<DioException>()));

      expect(adapter.requestCount, 2);
      expect(auth.refreshCount, 1);
      expect(adapter.authorizationHeaders, [
        'Bearer old-access',
        'Bearer new-access',
      ]);
      expect(store.access, isNull);
      expect(store.refresh, isNull);
      expect(expiredSessions, 1);
    },
  );

  test('successful refresh retries with the new access token', () async {
    final store = _FakeTokenStore(
      access: 'old-access',
      refresh: 'refresh-token',
    );
    final auth = _SuccessfulRefreshRepository();
    final adapter = _ResponseSequenceAdapter([401, 200]);
    final dio = buildApiClient(store, auth, httpClientAdapter: adapter);

    final response = await dio.get('/private');

    expect(response.statusCode, 200);
    expect(adapter.requestCount, 2);
    expect(auth.refreshCount, 1);
    expect(adapter.authorizationHeaders, [
      'Bearer old-access',
      'Bearer new-access',
    ]);
    expect(store.access, 'new-access');
  });

  test('failed refresh clears stored tokens and expires the session', () async {
    final store = _FakeTokenStore(
      access: 'old-access',
      refresh: 'expired-refresh',
    );
    final adapter = _ResponseSequenceAdapter([401]);
    var expiredSessions = 0;
    final dio = buildApiClient(
      store,
      _FailedRefreshRepository(),
      onSessionExpired: () => expiredSessions++,
      httpClientAdapter: adapter,
    );

    await expectLater(dio.get('/private'), throwsA(isA<DioException>()));

    expect(store.access, isNull);
    expect(store.refresh, isNull);
    expect(expiredSessions, 1);
    expect(adapter.requestCount, 1);
  });

  test('API errors map 401, timeout, and offline to friendly messages', () {
    final request = RequestOptions(path: '/private');

    expect(
      apiErrorMessage(
        DioException(
          requestOptions: request,
          response: Response(requestOptions: request, statusCode: 401),
        ),
      ),
      'Sesi Anda berakhir. Silakan masuk kembali.',
    );
    expect(
      apiErrorMessage(
        DioException(
          requestOptions: request,
          type: DioExceptionType.connectionTimeout,
        ),
      ),
      'Koneksi ke server terlalu lama. Periksa jaringan lalu coba lagi.',
    );
    expect(
      apiErrorMessage(
        DioException(
          requestOptions: request,
          type: DioExceptionType.connectionError,
        ),
      ),
      'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
    );
  });
}

class _FakeTokenStore implements TokenRepository {
  _FakeTokenStore({this.access, this.refresh});

  String? access;
  String? refresh;

  @override
  Future<String?> readAccess() async => access;

  @override
  Future<String?> readRefresh() async => refresh;

  @override
  Future<void> save({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }
}

class _SuccessfulRefreshRepository implements AuthRepository {
  int refreshCount = 0;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<String> refresh(String refreshToken) async {
    refreshCount++;
    return 'new-access';
  }
}

class _FailedRefreshRepository implements AuthRepository {
  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<String> refresh(String refreshToken) async {
    throw const FormatException('expired');
  }
}

class _ResponseSequenceAdapter implements HttpClientAdapter {
  _ResponseSequenceAdapter(this.statusCodes);

  final List<int> statusCodes;
  int requestCount = 0;
  final authorizationHeaders = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final statusCode = statusCodes[requestCount];
    requestCount++;
    final authorization = options.headers['Authorization'];
    authorizationHeaders.add(authorization is String ? authorization : null);
    return ResponseBody.fromString('', statusCode);
  }

  @override
  void close({bool force = false}) {}
}
