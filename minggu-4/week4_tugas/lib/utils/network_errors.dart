import 'package:dio/dio.dart';

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
        if (code == 404) return 'Data tidak ditemukan (404).';
        if (code == 500) return 'Terjadi gangguan pada server (500).';
        return 'Server merespons dengan kesalahan ($code).';
      default:
        return 'Terjadi kesalahan jaringan yang tidak diketahui.';
    }
  }
  return 'Terjadi kesalahan tak terduga: $error';
}