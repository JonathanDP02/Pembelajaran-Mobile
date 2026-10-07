import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';

import 'messaging/push_service.dart';
import 'data/api_client.dart';
import 'providers/auth_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/announcement_page.dart';
import 'routes.dart';

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
        builder: (_, s) => AnnouncementPage(id: s.pathParameters['id'] ?? ''),
      ),
    ],
  );
});

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage _) async {
  // Background handlers run in a separate isolate; do not use BuildContext or Riverpod here.
  await Firebase.initializeApp();
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

String formatTokenForDebug(String token) =>
    token.length > 12 ? '${token.substring(0, 12)}...' : token;

void listenForeground(void Function(String route) onRoute) {
  FirebaseMessaging.onMessage.listen((message) async {
    await showForegroundNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    onRoute(routeFromMessage(message.data));
  });
}

Future<void> handleTerminated(void Function(String route) onRoute) async {
  final message = await FirebaseMessaging.instance.getInitialMessage();
  final route = message == null
      ? pendingDeepLink
      : routeFromMessage(message.data);
  pendingDeepLink = null;
  if (route != null && route.isNotEmpty) onRoute(route);
}

String _currentPlatformName() => switch (defaultTargetPlatform) {
  TargetPlatform.android => 'android',
  TargetPlatform.iOS => 'ios',
  _ => 'unknown',
};

Future<void> _registerFcmToken(Dio dio, String token) async {
  try {
    await dio.post(
      '/devices',
      data: {'fcm_token': token, 'platform': _currentPlatformName()},
    );
  } on DioException catch (error) {
    debugPrint(
      'FCM token registration failed '
      '(type: ${error.type}, status: ${error.response?.statusCode ?? 'none'}).',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 1. [BARU - Praktikum 3] Mendaftarkan Background Handler (Top-level)
  registerBackgroundHandler();

  // 2. Minta izin & inisialisasi local notification
  await requestNotificationPermission();
  await initLocalNotifications();

  // 3. Buat ProviderContainer agar state Riverpod bisa diisi sebelum UI muncul
  final container = ProviderContainer();
  final dio = buildApiClient(
    container.read(tokenStoreProvider),
    container.read(authRepositoryProvider),
    onSessionExpired: () => container.invalidate(authStateProvider),
  );

  // 4. Inisialisasi FCM token & lifecycle
  await initFcmToken(
    onToken: (token) async {
      // A. Potong token untuk tampilan debug (12 karakter pertama + ...)
      final truncatedToken = formatTokenForDebug(token);
      fcmTokenNotifier.value = truncatedToken;

      debugPrint('FCM Token (Truncated): $truncatedToken');

      // B. [BARU - Praktikum 2/3] Kirim token FCM ke backend kampus via Dio
      await _registerFcmToken(dio, token);
    },
  );

  // 5. Jalankan aplikasi menggunakan UncontrolledProviderScope
  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    // [BARU - Praktikum 3] Jalankan listener penanganan klik notifikasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = ref.read(routerProvider);

      setNotificationRouteHandler(router.go);
      listenForeground((route) => router.go(route));
      unawaited(handleTerminated((route) => router.go(route)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Campus Notify',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
