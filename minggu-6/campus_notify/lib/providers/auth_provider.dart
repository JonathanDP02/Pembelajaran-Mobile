import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../data/api_errors.dart';
import '../data/token_store.dart';
import '../data/auth_repository.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<bool> {
  String? errorMessage;

  @override
  Future<bool> build() async {
    errorMessage = null;
    try {
      final token = await ref.watch(tokenStoreProvider).readAccess();
      return token != null;
    } on Exception catch (error) {
      errorMessage = apiErrorMessage(error);
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    errorMessage = null;
    state = const AsyncLoading();
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      await ref
          .read(tokenStoreProvider)
          .save(access: session.access, refresh: session.refresh);
      state = const AsyncData(true);
    } on DioException catch (error) {
      errorMessage = apiErrorMessage(error);
      state = const AsyncData(false);
    } on Exception catch (error) {
      errorMessage = apiErrorMessage(error);
      state = const AsyncData(false);
    }
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    errorMessage = null;
    ref.invalidateSelf();
  }
}