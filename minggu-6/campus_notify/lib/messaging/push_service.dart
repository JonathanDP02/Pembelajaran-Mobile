import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../routes.dart';

// StateProvider untuk menyimpan token terpotong
final fcmTokenNotifier = ValueNotifier<String>('Memuat token...');

final _local = FlutterLocalNotificationsPlugin();
const _announcementTopic = 'pengumuman-kampus';
const _notificationChannel = AndroidNotificationChannel(
  'pengumuman',
  'Pengumuman Kampus',
  description: 'Notifikasi pengumuman kampus',
  importance: Importance.high,
);

String? pendingDeepLink;
void Function(String route)? _onNotificationRoute;

void setNotificationRouteHandler(void Function(String route) handler) {
  _onNotificationRoute = handler;
  final route = pendingDeepLink;
  if (route != null && route.isNotEmpty) {
    pendingDeepLink = null;
    handler(route);
  }
}

void _handleLocalNotificationResponse(NotificationResponse response) {
  final route = response.payload;
  if (route == null || route.isEmpty) return;

  final handler = _onNotificationRoute;
  if (handler == null) {
    pendingDeepLink = route;
  } else {
    handler(route);
  }
}

Future<bool> requestNotificationPermission() async {
  // Android 13+ displays the POST_NOTIFICATIONS runtime prompt here.
  // On iOS, Firebase Messaging requests alert, badge, and sound authorization.
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
  );
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

Future<void> initLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await _local.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: _handleLocalNotificationResponse,
  );

  await _local
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(_notificationChannel);

  final launchDetails = await _local.getNotificationAppLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    pendingDeepLink = launchDetails?.notificationResponse?.payload;
  }
}

Future<void> showForegroundNotification(RemoteMessage message) async {
  final payload = routeFromMessage(message.data);

  const androidDetails = AndroidNotificationDetails(
    'pengumuman',
    'Pengumuman Kampus',
    importance: Importance.high,
    priority: Priority.high,
  );
  const iOSDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  await _local.show(
    id: message.hashCode,
    title: message.notification?.title ?? 'Pengumuman',
    body: message.notification?.body ?? '',
    notificationDetails: const NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    ),
    payload: payload,
  );
}

Future<void> subscribeToAnnouncements() =>
    FirebaseMessaging.instance.subscribeToTopic(_announcementTopic);

Future<void> unsubscribeFromAnnouncements() =>
    FirebaseMessaging.instance.unsubscribeFromTopic(_announcementTopic);

Future<void> initFcmToken({
  required Future<void> Function(String token) onToken,
}) async {
  // 1. Ambil token saat ini dan kirim ke backend.
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) await onToken(token);

  // 2. Token bisa berubah (reinstall, clear data, rotasi keamanan).
  //    Listener ini WAJIB ada, jika tidak backend menyimpan token basi.
  FirebaseMessaging.instance.onTokenRefresh.listen(onToken);

  // 3. Langganan topik kampus (mis. semua mahasiswa angkatan).
  await subscribeToAnnouncements();
}
