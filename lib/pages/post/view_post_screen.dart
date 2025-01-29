import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/utils/dateTimeUtil.dart';
import 'package:flutter_application_1/common/widgets/errorBoundary.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';
import 'package:flutter_application_1/common/widgets/commonProgressIndicator.dart';
import 'package:flutter_application_1/pages/post/post_comments.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ViewPostScreen extends StatefulWidget {
  final String postId;

  const ViewPostScreen({super.key, required this.postId});

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  bool isLiked = false; // 좋아요 상태
  int likes = 0; // 좋아요 개수
  int views = 0; // 조회수

  final ValueNotifier<bool> isLikedNotifier = ValueNotifier(false);
  final ValueNotifier<int> likesNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final String postId = widget.postId;

    print("Current ViewPost Id: " + postId);
    final FirestoreService firestoreService = FirestoreService();

    return ErrorBoundary(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              try {
                GoRouter.of(context).pop();
              } catch (e) {
                print(e);
                context.go('/mainCommunity');
              }
            },
          ),
          title: const Text('게시글'),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                final String shareUrl = '';
                Share.share('Check out this post: $shareUrl');
              },
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _incrementViewsAndFetchPost(firestoreService, postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CommonProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('일시적 오류입니다. 다시 시도해주세요.'));
            } else if (snapshot.data == null) {
              return const Center(child: Text('게시글을 찾을 수 없습니다.'));
            } else {
              final data = snapshot.data!;
              final String category = data['category'] ?? '미분류';
              final String title = data['title'] ?? '제목 없음';
              final String content = data['content'] ?? '내용 없음';
              final String author = data['author'] ?? '익명';
              final String time = formatTimestamp(data['register_time']);
              final int comments = data['comments_cnt'] ?? 0;
              views = data['views_cnt'] ?? 0;
              likes = data['likes_cnt'] ?? 0; // 좋아요 초기화

              likesNotifier.value = data['likes_cnt'] ?? 0;
              isLikedNotifier.value = false; // 기본 값 초기화

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryTag(category),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$author | $time',
                        style: const TextStyle(
                            color: MyColors.subFontColor, fontSize: 14),
                      ),
                      const Divider(height: 24, thickness: 1),
                      Text(
                        content,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(height: 24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLikesSection(firestoreService, postId),
                          Text('댓글 $comments   조회 $views회'),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      PostComments(postId: postId),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /// 조회수를 증가시키고 게시글 데이터를 가져오는 메서드
  Future<Map<String, dynamic>?> _incrementViewsAndFetchPost(
      FirestoreService firestoreService, String postId) async {
    await firestoreService.incrementViews('posts', postId);
    return await firestoreService.getPostById('posts', postId);
  }

  // 좋아요 UI와 동작 분리
  Widget _buildLikesSection(FirestoreService firestoreService, String postId) {
    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isLikedNotifier,
          builder: (context, isLiked, child) {
            return IconButton(
              icon: Icon(
                isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
              ),
              onPressed: () {
                // 즉시 값 변경
                final newValue = !isLiked;
                final newLikes = newValue
                    ? likesNotifier.value + 1
                    : likesNotifier.value - 1;

                isLikedNotifier.value = newValue;
                likesNotifier.value = newLikes;

                firestoreService.updateLikesInBackground(
                    postId, newValue, newLikes);
              },
            );
          },
        ),
        const SizedBox(width: 4),
        ValueListenableBuilder<int>(
          valueListenable: likesNotifier,
          builder: (context, likes, child) {
            return Text('$likes');
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    isLikedNotifier.dispose();
    likesNotifier.dispose();
    super.dispose();
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: MyColors.mainColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: Text(
        category,
        style: const TextStyle(color: MyColors.mainFontColor),
      ),
    );
  }
}
