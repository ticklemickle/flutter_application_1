import 'package:flutter/material.dart';

class ViewPostScreen extends StatelessWidget {
  const ViewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigator를 통해 전달된 데이터를 받습니다.
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // 전달된 데이터를 변수에 저장
    final String category = arguments['category'];
    final String title = arguments['title'];
    final String author = arguments['author'];
    final String time = arguments['time'];
    final int comments = arguments['comments'];
    final int views = arguments['views'];
    final int likes = arguments['likes'];

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 태그 예시 (데이터에 따라 동적 구성 가능)
            _buildCategoryTag(category),
            const SizedBox(height: 8),
            // 게시글 제목
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // 작성자, 시간 정보
            Text(
              '$author | $time',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Divider(height: 24, thickness: 1),
            // 게시글 본문 예시 (본문 데이터 추가 가능)
            const Text(
              '게시글 본문은 현재 제공된 데이터에 없습니다.\n추후 데이터를 추가하여 본문 내용을 표시하세요.',
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
