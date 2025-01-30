import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/utils/dateTimeUtil.dart';
import 'package:flutter_application_1/common/widgets/errorBoundary.dart';
import 'package:flutter_application_1/common/widgets/commonProgressIndicator.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ViewPostScreen extends StatefulWidget {
  final String postId;

  const ViewPostScreen({super.key, required this.postId});

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  bool isLiked = false;
  int likes = 0;
  int views = 0;

  final ValueNotifier<bool> isLikedNotifier = ValueNotifier(false);
  final ValueNotifier<int> likesNotifier = ValueNotifier(0);
  final ValueNotifier<int> commentsNotifier = ValueNotifier(0);

  final TextEditingController _commentController = TextEditingController();
  final ValueNotifier<bool> isTextNotEmpty = ValueNotifier(false);
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
    _commentController.addListener(() {
      isTextNotEmpty.value = _commentController.text.isNotEmpty;
    });
    _loadPostData();
  }

  void _loadPostData() async {
    final data = await firestoreService.getPostById('posts', widget.postId);
    if (data != null) {
      likesNotifier.value = data['likes_cnt'] ?? 0;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    isTextNotEmpty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String postId = widget.postId;

    return ErrorBoundary(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              try {
                GoRouter.of(context).pop();
              } catch (e) {
                context.go('/mainCommunity');
              }
            },
          ),
          title: const Text('게시글'),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                Share.share('Check out this post: ');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Column(
              children: [
                FutureBuilder<Map<String, dynamic>?>(
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
                      final String time =
                          formatTimestamp(data['register_time']);
                      commentsNotifier.value = data['comments_cnt'] ?? 0;
                      views = data['views_cnt'] ?? 0;
                      likesNotifier.value = data['likes_cnt'] ?? 0;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryTag(category),
                            const SizedBox(height: 8),
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('$author | $time',
                                style: const TextStyle(
                                    color: MyColors.subFontColor,
                                    fontSize: 14)),
                            Text(content, style: const TextStyle(fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildLikesSection(firestoreService, postId),
                                StreamBuilder<QuerySnapshot>(
                                  stream: firestoreService
                                      .getCommentsStream(widget.postId),
                                  builder: (context, snapshot) {
                                    int commentCount = 0;
                                    if (snapshot.hasData) {
                                      commentCount = snapshot.data!.docs.length;
                                    }
                                    return Text(
                                        '댓글 $commentCount   조회 $views회');
                                  },
                                ),
                              ],
                            ),
                            // 댓글 리스트
                            StreamBuilder<QuerySnapshot>(
                              stream: firestoreService
                                  .getCommentsStream(widget.postId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CommonProgressIndicator());
                                }

                                // 실시간 댓글 개수 업데이트
                                final commentCount = snapshot.hasData
                                    ? snapshot.data!.docs.length
                                    : 0;
                                commentsNotifier.value = commentCount;

                                if (commentCount == 0) {
                                  return const Center(
                                      child: Text('첫 댓글을 남겨주세요.'));
                                }

                                return Column(
                                  children: snapshot.data!.docs.map((doc) {
                                    return ListTile(
                                      title: Text(doc['text']),
                                      subtitle: Text(
                                          formatRelativeTime(doc['timestamp'])),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: _buildCommentInputField(),
      ),
    );
  }

  Future<Map<String, dynamic>?> _incrementViewsAndFetchPost(
      FirestoreService firestoreService, String postId) async {
    await firestoreService.incrementViews('posts', postId);
    return await firestoreService.getPostById('posts', postId);
  }

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

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: MyColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Text(category, style: const TextStyle(color: MyColors.mainFontColor)),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: '댓글을 남겨주세요.',
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColors.mainlightColor,
                    width: 2.0,
                  ),
                ),
              ),
              maxLength: 500,
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: isTextNotEmpty,
            builder: (context, isNotEmpty, child) {
              return ElevatedButton(
                onPressed: isNotEmpty
                    ? () async {
                        await firestoreService.addComment(
                          widget.postId,
                          _commentController.text,
                        );
                        _commentController.clear();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isNotEmpty ? MyColors.mainColor : MyColors.grey,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '남기기',
                  style: TextStyle(
                    color: MyColors.mainFontColor,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
