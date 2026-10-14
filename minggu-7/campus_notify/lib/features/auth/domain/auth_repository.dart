class AuthSession {
  const AuthSession({required this.access, required this.refresh});
  final String access;
  final String refresh;
}

abstract interface class AuthRepository {
  Future<AuthSession> login({required String email, required String password});

  Future<String> refresh(String refreshToken);
}