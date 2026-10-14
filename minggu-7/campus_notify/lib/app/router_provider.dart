import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/routes.dart';
import '../features/announcements/presentation/announcement_page.dart';
import '../features/auth/application/auth_provider.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/notifications/presentation/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final loggedIn = authAsync.value ?? false;

  return GoRouter(
    redirect: (context, state) {
      final goingLogin = state.matchedLocation == AppRoutes.login;
      if (!loggedIn && !goingLogin) return AppRoutes.login;
      if (loggedIn && goingLogin) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      GoRoute(
        path: AppRoutes.announcement,
        builder: (_, state) =>
            AnnouncementPage(id: state.pathParameters['id'] ?? ''),
      ),
    ],
  );
});
