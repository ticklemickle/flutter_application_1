import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int maxPage;

  FirestoreService({this.maxPage = 10});

  Future<void> addPost({
    required String author,
    required String category,
    required String title,
    required String content,
    required DateTime registerTime,
  }) async {
    String timestamp = DateFormat('yyyyMMddHHmmss').format(registerTime);
    String randomNum =
        Random().nextInt(9999).toString().padLeft(4, '0'); // 4자리 난수
    String documentId = '$timestamp$randomNum';

    // 2️⃣ Firestore에 문서 추가
    await _firestore.collection('posts').doc(documentId).set({
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

  Future<List<Map<String, dynamic>>> getPosts({
    required int selectedCategoryIndex,
    required List<String> categories,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(maxPage);

      if (selectedCategoryIndex != 0) {
        final selectedCategory = categories[selectedCategoryIndex];
        query = query.where('category', isEqualTo: selectedCategory);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return {
          ...data,
          'id': doc.id,
          'docRef': doc, // 🔥 문서 객체 추가
        };
      }).toList();
    } catch (e) {
      print('🔥 Firestore 오류: $e');
      return [];
    }
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

  Future<void> updateLikesInBackground(String postId, int likes) async {
    try {
      await updateLikes('posts', postId, likes);
    } catch (e) {
      // 에러 처리: 예를 들어 로그를 남기거나 사용자에게 알림을 표시
      print('Failed to update likes: $e');
    }
  }

  Future<void> updateLikes(
      String collection, String docId, int likesCnt) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({'likes_cnt': likesCnt});
  }

  Future<void> updateCommentsInBackground(
      String postId, int commentsCnt) async {
    try {
      await updateComments('posts', postId, commentsCnt);
    } catch (e) {
      // 에러 처리: 예를 들어 로그를 남기거나 사용자에게 알림을 표시
      print('Failed to update comments_cnt: $e');
    }
  }

  Future<void> updateComments(
      String collection, String docId, int commentsCnt) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({'comments_cnt': commentsCnt});
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
