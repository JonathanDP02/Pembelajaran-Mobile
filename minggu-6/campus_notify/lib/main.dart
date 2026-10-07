import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'messaging/push_service.dart';

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
        builder: (_, s) =>
            AnnouncementPage(id: s.pathParameters['id'] ?? ''),
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
 // 1. Minta izin & inisialisasi local notification
  await requestNotificationPermission();
  await initLocalNotifications();

  // 2. Buat ProviderContainer agar state Riverpod bisa diisi sebelum UI muncul
  final container = ProviderContainer();

  // 3. Inisialisasi token & masukkan ke Provider State
  await initFcmToken(onToken: (token) async {
    // Potong token untuk tampilan debug (12 karakter pertama + ...)
    final truncatedToken = token.length > 12 ? '${token.substring(0, 12)}...' : token;
    
    // Kirim ke state Riverpod agar TAMPIL DI LAYAR
    fcmTokenNotifier.value = truncatedToken;

    print("FCM Token (Truncated): $truncatedToken");
  });

  // 4. Jalankan aplikasi menggunakan UncontrolledProviderScope
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Campus Notify',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}