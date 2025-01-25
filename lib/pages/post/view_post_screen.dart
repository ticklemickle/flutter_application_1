import 'package:flutter/material.dart';

class ViewPostScreen extends StatelessWidget {
  const ViewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              // 공유 기능
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryTag('부동산'),
            const SizedBox(height: 8),
            const Text(
              '힐리오시티 구매 타이밍 일까...?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              '경기도 고양시 남자 | 2025.01.18 16:05',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Divider(height: 24, thickness: 1),
            const Text(
              '말그대로 지금 헬리오 저점인 것 같은데 철들 생각은 어때? 누군 더 떨어질 것 같다고 하는데 지금이 최저점이라 고도 하는데 잘 모르겠네.\n\n잘하시는 분들의 고견 부탁드립니다.',
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.thumb_up_alt_outlined),
                    SizedBox(width: 4),
                    Text('12'),
                    SizedBox(width: 16),
                    Icon(Icons.thumb_down_alt_outlined),
                  ],
                ),
                const Text('댓글 0   조회 131회'),
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
