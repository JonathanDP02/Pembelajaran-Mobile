import 'package:campus_notify/features/auth/application/auth_provider.dart';
import 'package:campus_notify/features/auth/data/demo_auth_repository.dart';
import 'package:campus_notify/features/auth/domain/token_repository.dart';
import 'package:campus_notify/features/auth/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login page shows a friendly validation message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenRepositoryProvider.overrideWithValue(_MemoryTokenStore()),
          authRepositoryProvider.overrideWithValue(DemoAuthRepository()),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'invalid-email');
    await tester.enterText(find.byType(TextField).at(1), 'short');
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Email atau kata sandi tidak valid.'), findsOneWidget);
  });
}

class _MemoryTokenStore implements TokenRepository {
  _MemoryTokenStore();

  String? _access;
  String? _refresh;

  @override
  Future<String?> readAccess() async => _access;

  @override
  Future<String?> readRefresh() async => _refresh;

  @override
  Future<void> save({required String access, required String refresh}) async {
    _access = access;
    _refresh = refresh;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }
}
