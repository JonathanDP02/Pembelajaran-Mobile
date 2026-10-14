abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcement = '/pengumuman/:id';

  static String announcementById(String id) => '/pengumuman/$id';
}

String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route'];
  if (route is! String || route.trim().isEmpty) return AppRoutes.home;
  final normalizedRoute = route.trim();
  return normalizedRoute.startsWith('/')
      ? normalizedRoute
      : '/$normalizedRoute';
}
