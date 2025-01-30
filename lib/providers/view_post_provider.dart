import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils/DateTimeUtil.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';

class ViewPostProvider extends ChangeNotifier {
  final FirestoreService firestoreService;
  final String postId;

  bool isLiked = false;
  ValueNotifier<int> likesNotifier = ValueNotifier(0);
  ValueNotifier<int> commentsNotifier = ValueNotifier(0);
  ValueNotifier<int> viewsNotifier = ValueNotifier(0);

  bool isLoading = true;

  String category = "";
  String title = "";
  String author = "";
  String time = "";
  String content = "";

  ViewPostProvider({required this.firestoreService, required this.postId}) {
    loadPostData();
  }

  Future<void> loadPostData() async {
    final data = await firestoreService.getPostById('posts', postId);
    if (data != null) {
      category = data['category'] ?? '미분류';
      title = data['title'] ?? '제목 없음';
      author = data['author'] ?? '익명';
      time = formatTimestamp(data['register_time']);
      content = data['content'] ?? '내용 없음';

      likesNotifier.value = data['likes_cnt'] ?? 0;
      viewsNotifier.value = data['views_cnt'] ?? 0;
      commentsNotifier.value = data['comments_cnt'] ?? 0;

      // 조회수 +1 증가
      await firestoreService.incrementViews('posts', postId);
      viewsNotifier.value += 1;
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleLike() {
    isLiked = !isLiked;
    likesNotifier.value += isLiked ? 1 : -1;

    firestoreService.updateLikesInBackground(
        postId, isLiked, likesNotifier.value);
  }

  void updateCommentCount(int count) {
    commentsNotifier.value = count;
    // Future.microtask(() => notifyListeners());
  }
}
