abstract interface class TokenRepository {
  Future<void> save({required String access, required String refresh});

  Future<String?> readAccess();

  Future<String?> readRefresh();

  Future<void> clear();
}
