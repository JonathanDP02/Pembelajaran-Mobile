import '../../../core/failure.dart';
import '../domain/announcement.dart';
import '../domain/announcement_repository.dart';

class GetAnnouncements {
  const GetAnnouncements(this.repository);

  final AnnouncementRepository repository;

  Future<({List<Announcement> announcements, Failure? failure})> call() async {
    try {
      return await repository.fetchAnnouncements();
    } on Failure catch (failure) {
      return (announcements: const <Announcement>[], failure: failure);
    } on Exception {
      return (
        announcements: const <Announcement>[],
        failure: const LocalFailure('Gagal memuat pengumuman.'),
      );
    }
  }
}
