import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/failure.dart';
import '../data/announcement_repository_impl.dart';
import '../domain/announcement.dart';
import '../domain/announcement_repository.dart';
import 'get_announcements.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => AnnouncementRepositoryImpl(),
);

final announcementProvider = FutureProvider<({List<Announcement> announcements, Failure? failure})>(
  (ref) async {
    final repository = ref.watch(announcementRepositoryProvider);
    return GetAnnouncements(repository).call();
  },
);
