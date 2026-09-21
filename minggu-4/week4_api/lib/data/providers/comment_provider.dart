import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../repositories/comment_repository.dart';
import '../api_client.dart';

// Provider untuk instance Dio terpusat
final dioProvider = Provider<Dio>((ref) => createDio());

// Provider untuk CommentRepository
final commentRepositoryProvider = Provider<CommentRepository>(
  (ref) => CommentRepository(ref.watch(dioProvider)),
);

// Menggunakan AsyncNotifier dengan penanganan parameter Family melalui konstruktor kelas
class CommentListNotifier extends AsyncNotifier<List<Comment>> {
  CommentListNotifier(this.postId);
  final int postId; // Menyimpan parameter family

  @override
  Future<List<Comment>> build() async {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.fetchComments(postId);
  }

  // Fungsi untuk memuat ulang data (refresh) berdasarkan postId yang tersimpan
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => 
      ref.read(commentRepositoryProvider).fetchComments(postId)
    );
  }
}

// Pendaftaran provider menggunakan .family dan menyertakan tipe argumen ketiganya (int)
final commentListProvider = AsyncNotifierProvider.family<CommentListNotifier, List<Comment>, int>(
  CommentListNotifier.new,
);

// Fungsi untuk menerjemahkan DioException ke pesan ramah pengguna
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi lambat atau timeout (10 detik). Periksa internet Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa jaringan Anda.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) return 'Data komentar tidak ditemukan (404).';
        if (code == 500) return 'Terjadi gangguan pada server (500). Coba lagi nanti.';
        return 'Server merespons dengan kesalahan ($code).';
      default:
        return 'Terjadi kesalahan jaringan yang tidak diketahui.';
    }
  }
  return 'Terjadi kesalahan tak terduga: $error';
}