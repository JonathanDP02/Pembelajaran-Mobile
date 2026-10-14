import '../../../core/failure.dart';
import 'announcement.dart';

abstract interface class AnnouncementRepository {
  Future<({List<Announcement> announcements, Failure? failure})> fetchAnnouncements();
}
