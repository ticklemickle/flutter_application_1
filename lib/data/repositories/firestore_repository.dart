import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(Map<String, dynamic> postData) async {
    await _firestore.collection('posts').add(postData);
  }

  Stream<List<Map<String, dynamic>>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost({
    required String category,
    required String title,
    required String content,
    required DateTime createdAt,
  }) async {
    await _firestore.collection('posts').add({
      'category': category,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    });
  }
}
