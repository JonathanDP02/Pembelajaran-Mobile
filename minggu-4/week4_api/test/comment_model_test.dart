import 'package:flutter_test/flutter_test.dart';
// Sesuaikan import path dengan struktur project Anda
import 'package:week4_api/data/models/comment.dart'; 

void main() {
  group('Comment.fromJson Unit Test', () {
    test('harus mengembalikan nilai default (aman null) jika field JSON hilang', () {
      // JSON dengan field yang sengaja dikosongkan / hilang
      final Map<String, dynamic> incompleteJson = {};

      final comment = Comment.fromJson(incompleteJson);

      // Memastikan cast defensif berfungsi dan memberikan nilai default yang aman
      expect(comment.postId, 0);
      expect(comment.id, 0);
      expect(comment.name, '');
      expect(comment.email, '');
      expect(comment.body, '');
    });

    test('harus memparsing data dengan benar jika JSON lengkap', () {
      final Map<String, dynamic> completeJson = {
        'postId': 1,
        'id': 5,
        'name': 'Test Name',
        'email': 'test@email.com',
        'body': 'Test body content',
      };

      final comment = Comment.fromJson(completeJson);

      expect(comment.postId, 1);
      expect(comment.id, 5);
      expect(comment.name, 'Test Name');
      expect(comment.email, 'test@email.com');
      expect(comment.body, 'Test body content');
    });
  });
}