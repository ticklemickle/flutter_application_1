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
    return _firestore
        .collection('posts')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return Post.fromMap(doc.data());
            } catch (e) {
              // 에러 발생 시 로그 출력 (문제가 되는 게시글의 ID 포함)
              print('Error parsing post with ID ${doc.id}: $e');
              return null; // 문제 발생 시 null 반환
            }
          })
          .where((post) => post != null)
          .cast<Post>()
          .toList();
    });
  }
}
