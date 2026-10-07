import 'package:dio/dio.dart';

String apiErrorMessage(Object error) {
  if (error is FormatException) {
    return 'Email atau kata sandi tidak valid.';
  }

  if (error is! DioException) {
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }

  if (error.response?.statusCode == 401) {
    return 'Sesi Anda berakhir. Silakan masuk kembali.';
  }

  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>
      'Koneksi ke server terlalu lama. Periksa jaringan lalu coba lagi.',
    DioExceptionType.connectionError =>
      'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
    _ => 'Permintaan gagal. Silakan coba lagi.',
  };
}
