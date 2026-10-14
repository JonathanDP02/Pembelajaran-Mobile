import '../../../core/failure.dart';
import '../domain/announcement.dart';
import '../domain/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  @override
  Future<({List<Announcement> announcements, Failure? failure})> fetchAnnouncements() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return (
        announcements: [
          Announcement(
            id: '1',
            title: 'Pendaftaran Workshop AI',
            body: 'Workshop AI dibuka untuk seluruh mahasiswa baru.',
            updatedAt: DateTime(2026, 9, 27),
          ),
          Announcement(
            id: '2',
            title: 'Jadwal Ujian Tengah Semester',
            body: 'Mengacu pada kalender akademik yang sudah disetujui.',
            updatedAt: DateTime(2026, 10, 2),
          ),
        ],
        failure: null,
      );
    } on Exception {
      return (
        announcements: const <Announcement>[],
        failure: const LocalFailure('Gagal memuat pengumuman. Silakan coba lagi.'),
      );
    }
  }
}
