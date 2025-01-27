import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/post.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost({
    required String author,
    required String category,
    required String title,
    required String content,
    required DateTime registerTime,
  }) async {
    await _firestore.collection('posts').add({
      'author': author,
      'category': category,
      'title': title,
      'content': content,
      'comments_cnt': 0, // 초기값
      'views_cnt': 0, // 초기값
      'likes_cnt': 0, // 초기값
      'register_time': registerTime,
      'last_mod_time': registerTime,
    });
  }

  Stream<List<Post>> getPosts({String? category}) {
    final query = _firestore.collection('posts');

    // 카테고리가 null이 아니면 where 조건 추가
    final filteredQuery =
        category != null ? query.where('category', isEqualTo: category) : query;

    return filteredQuery.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return Post.fromMap(doc.data());
            } catch (e) {
              print('Error parsing post with ID ${doc.id}: $e');
              return null;
            }
          })
          .where((post) => post != null) // null 제거
          .cast<Post>() // Post 타입으로 변환
          .toList();
    });
  }

  Future<Map<String, dynamic>?> getPostById(
      String collection, String documentId) async {
    try {
      final DocumentSnapshot document =
          await _firestore.collection(collection).doc(documentId).get();

      if (document.exists) {
        return document.data() as Map<String, dynamic>;
      } else {
        return null; // 문서가 존재하지 않을 때
      }
    } catch (e) {
      // 오류 처리
      print('Firestore 조회 오류: $e');
      return null;
    }
  }
}
