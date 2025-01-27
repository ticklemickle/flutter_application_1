import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/post.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';

class CommunityContent extends StatefulWidget {
  const CommunityContent({super.key}); // super.key로 변경

  @override
  _CommunityContentState createState() => _CommunityContentState();
}

class _CommunityContentState extends State<CommunityContent> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['전체', '부동산', '주식', '코인', '재테크', '기타'];
  late Stream<List<Post>> postStream;

  @override
  void initState() {
    super.initState();
    postStream = FirestoreService().getPosts(); // 초기에는 모든 게시글을 가져옴
  }

  void _updatePostStream() {
    final selectedCategory =
        selectedCategoryIndex == 0 ? null : categories[selectedCategoryIndex];
    setState(() {
      postStream = FirestoreService().getPosts(category: selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 검색바
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '검색',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // 게시글 작성 화면으로 이동
                  Navigator.pushNamed(context, '/addPost');
                },
              ),
            ],
          ),
        ),
        // 카테고리 선택
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: SizedBox(
                    width: 70, // 고정된 너비를 설정
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          color: Colors.black, // 텍스트 색상
                          fontSize: 14, // 글씨 크기
                        ),
                      ),
                    ),
                  ),
                  selected: selectedCategoryIndex == index,
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey[200], // 비선택 시 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        selectedCategoryIndex = index;
                        _updatePostStream(); // 선택된 카테고리에 따라 게시글 업데이트
                      });
                    }
                  },
                  showCheckmark: false, // 체크 모양 제거
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        // 게시글 리스트
        Expanded(
          child: StreamBuilder<List<Post>>(
            stream: postStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('게시물이 없습니다.'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];

                  return InkWell(
                    onTap: () {
                      // view_post_screen.dart로 이동
                      Navigator.pushNamed(context, '/viewPost', arguments: {
                        'category': post.category,
                        'title': post.title,
                        'author': post.author,
                        'time': post.registerTime.toString(),
                        'comments': post.commentsCnt,
                        'views': post.viewsCnt,
                        'likes': post.likesCnt,
                      });
                    },
                    child: _buildPostItem(
                      title: post.title,
                      author: post.author,
                      time: post.registerTime.toString(),
                      comments: post.commentsCnt,
                      views: post.viewsCnt,
                      likes: post.likesCnt,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem({
    required String title,
    required String author,
    required String time,
    required int comments,
    required int views,
    required int likes,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to view_post_screen.dart
        Navigator.pushNamed(context, '/viewPost', arguments: {
          'title': title,
          'author': author,
          'time': time,
          'comments': comments,
          'views': views,
          'likes': likes,
        });
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '$time | $author',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('$comments'),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.visibility,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('$views'),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('$likes'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider at the bottom of each item
          const Divider(color: Colors.grey, thickness: 0.5, height: 1),
        ],
      ),
    );
  }
}
