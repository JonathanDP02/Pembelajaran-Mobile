String formatDate(DateTime date) {
  final monthNames = <int, String>{
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agu',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des',
  };

  final day = date.day.toString().padLeft(2, '0');
  final month = monthNames[date.month] ?? 'Bln';
  final year = date.year;

  return '$day $month $year';
}

String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route'];
  if (route is! String || route.trim().isEmpty) return '/';

  final normalized = route.trim();
  return normalized.startsWith('/') ? normalized : '/$normalized';
}

String parseRouteFromMessage(Map<String, dynamic> data) => routeFromMessage(data);
