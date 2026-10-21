import 'package:campus_notify/core/failure.dart';
import 'package:campus_notify/features/notes/data/notes_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalNotesRepository repository;

  setUp(() {
    repository = LocalNotesRepository();
  });

  test('addNote menolak judul kosong atau hanya berisi spasi', () async {
    final result = await repository.addNote(title: '   ');

    expect(result.note, isNull);
    expect(result.failure, isA<LocalFailure>());
    expect(result.failure?.message, 'Judul catatan tidak boleh kosong.');
  });

  test('addNote menyimpan judul setelah spasi tepi dihapus', () async {
    final result = await repository.addNote(title: '  Catatan kuliah  ');

    expect(result.failure, isNull);
    expect(result.note?.title, 'Catatan kuliah');
  });
}
