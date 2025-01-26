import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String author;
  final String title;
  final String content;
  final int commentsCnt;
  final int viewsCnt;
  final int likesCnt;
  final String category;
  final DateTime registerTime;
  final DateTime lastModTime;

  Post({
    required this.author,
    required this.title,
    required this.content,
    required this.commentsCnt,
    required this.viewsCnt,
    required this.likesCnt,
    required this.category,
    required this.registerTime,
    required this.lastModTime,
  });

  // Firestore에서 읽어올 때 사용
  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      author: data['author'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      commentsCnt: data['comments_cnt'] ?? 0,
      viewsCnt: data['views_cnt'] ?? 0,
      likesCnt: data['likes_cnt'] ?? 0,
      category: data['category'] ?? '',
      registerTime: (data['register_time'] as Timestamp).toDate(),
      lastModTime: (data['last_mod_time'] as Timestamp).toDate(),
    );
  }

  // Firestore에 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'title': title,
      'content': content,
      'comments_cnt': commentsCnt,
      'views_cnt': viewsCnt,
      'likes_cnt': likesCnt,
      'category': category,
      'register_time': registerTime,
      'last_mod_time': lastModTime,
    };
  }
}
