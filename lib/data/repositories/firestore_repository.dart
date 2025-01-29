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

  /// 조회수 증가 메서드
  Future<void> incrementViews(String collection, String postId) async {
    final DocumentReference postRef =
        _firestore.collection(collection).doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final currentViews = data['views_cnt'] ?? 0;
        transaction.update(postRef, {'views_cnt': currentViews + 1});
      }
    });
  }

  Future<void> updateLikesInBackground(
      String postId, bool isLiked, int likes) async {
    try {
      await updateLikes('posts', postId, likes);
    } catch (e) {
      // 에러 처리: 예를 들어 로그를 남기거나 사용자에게 알림을 표시
      print('Failed to update likes: $e');
    }
  }

  Future<void> updateLikes(
      String collection, String docId, int newLikes) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({'likes_cnt': newLikes});
  }

  Stream<QuerySnapshot> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 🔹 댓글 추가 메서드
  Future<void> addComment(String postId, String text) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
