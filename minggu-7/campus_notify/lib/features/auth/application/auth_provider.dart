import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_repository.dart';
import '../domain/auth_failure.dart';
import '../domain/token_repository.dart';

final tokenRepositoryProvider = Provider<TokenRepository>(
  (ref) => throw StateError('TokenRepository must be provided by the app.'),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw StateError('AuthRepository must be provided by the app.'),
);

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<bool> {
  String? errorMessage;

  @override
  Future<bool> build() async {
    errorMessage = null;
    try {
      final token = await ref.watch(tokenRepositoryProvider).readAccess();
      return token != null;
    } on AuthFailure catch (error) {
      errorMessage = error.message;
      return false;
    } on Exception {
      errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
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
          .read(tokenRepositoryProvider)
          .save(access: session.access, refresh: session.refresh);
      state = const AsyncData(true);
    } on AuthFailure catch (error) {
      errorMessage = error.message;
      state = const AsyncData(false);
    } on Exception {
      errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      state = const AsyncData(false);
    }
  }

  Future<void> logout() async {
    await ref.read(tokenRepositoryProvider).clear();
    errorMessage = null;
    ref.invalidateSelf();
  }
}