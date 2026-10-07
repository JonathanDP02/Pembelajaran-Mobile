import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'messaging/push_service.dart';
import 'data/api_client.dart';
import 'providers/auth_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/announcement_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final loggedIn = authAsync.value ?? false;

  return GoRouter(
    redirect: (context, state) {
      final goingLogin = state.matchedLocation == '/login';
      if (!loggedIn && !goingLogin) return '/login';
      if (loggedIn && goingLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/pengumuman/:id',
        builder: (_, s) => AnnouncementPage(id: s.pathParameters['id'] ?? ''),
      ),
    ],
  );
});

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage _) async {
  await Firebase.initializeApp();
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

String formatTokenForDebug(String token) =>
    token.length > 12 ? '${token.substring(0, 12)}...' : token;

String _routeFromMessage(RemoteMessage? message) {
  final route = message?.data['route'];
  return route is String && route.isNotEmpty ? route : '/';
}

void listenForeground(void Function(String route) onRoute) {
  FirebaseMessaging.onMessage.listen((message) async {
    await showForegroundNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    onRoute(_routeFromMessage(message));
  });
}

Future<void> handleTerminated(void Function(String route) onRoute) async {
  final message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    onRoute(_routeFromMessage(message));
  }

  final route = pendingDeepLink;
  if (route != null && route.isNotEmpty) onRoute(route);
  pendingDeepLink = null;
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
  );

  // 4. Inisialisasi FCM token & lifecycle
  await initFcmToken(
    onToken: (token) async {
      // A. Potong token untuk tampilan debug (12 karakter pertama + ...)
      final truncatedToken = formatTokenForDebug(token);
      fcmTokenNotifier.value = truncatedToken;

      print("FCM Token (Truncated): $truncatedToken");

      // B. [BARU - Praktikum 2/3] Kirim token FCM ke backend kampus via Dio
      try {
        await dio.post(
          '/devices',
          data: {'fcm_token': token, 'platform': 'android'},
        );
      } catch (_) {
        // Abaikan error jika API mock belum siap
      }
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
