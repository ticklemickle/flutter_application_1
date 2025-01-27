import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils/dateTimeUtil.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';

class ViewPostScreen extends StatelessWidget {
  const ViewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigator를 통해 전달된 문서 ID를 받습니다.
    final String postId = ModalRoute.of(context)?.settings.arguments as String;

    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('게시글'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 공유 기능 (추후 구현)
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: firestoreService.getPostById(
            'posts', postId), // 'posts'는 Firestore 컬렉션 이름
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는데 실패했습니다.'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('게시글을 찾을 수 없습니다.'));
          } else {
            // Firestore에서 가져온 데이터를 Map으로 변환
            final data = snapshot.data!;

            // 데이터 변수 할당
            final String category = data['category'] ?? '미분류';
            final String title = data['title'] ?? '제목 없음';
            final String content = data['content'] ?? '내용 없음';
            final String author = data['author'] ?? '익명';
            final String time = formatTimestamp(data['register_time']);
            final int comments = data['comments_cnt'] ?? 0;
            final int views = data['views_cnt'] ?? 0;
            final int likes = data['likes_cnt'] ?? 0;

            return Padding(
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
                  // 작성자, 시간 정보
                  Text(
                    '$author | $time',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const Divider(height: 24, thickness: 1),
                  Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                  const Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up_alt_outlined),
                          const SizedBox(width: 4),
                          Text('$likes'), // 좋아요 개수
                          const SizedBox(width: 16),
                          const Icon(Icons.thumb_down_alt_outlined),
                        ],
                      ),
                      Text('댓글 $comments   조회 $views회'), // 댓글과 조회수
                    ],
                  ),
                  const Divider(height: 24, thickness: 1),
                  ElevatedButton(
                    onPressed: () {
                      // 댓글 남기기 동작
                    },
                    child: const Text('첫 댓글 남기기'),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: '댓글을 남겨주세요.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
