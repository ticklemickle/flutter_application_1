import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/post.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';

class MainCommunityScreen extends StatefulWidget {
  const MainCommunityScreen({Key? key}) : super(key: key);

  @override
  _MainCommunityScreenState createState() => _MainCommunityScreenState();
}

class _MainCommunityScreenState extends State<MainCommunityScreen> {
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
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Main Community'),
      // ),
      body: Column(
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

                return ListView(
                  children: snapshot.data!
                      .map((post) => _buildPostItem(
                            title: post.title,
                            author: post.author,
                            time: post.registerTime.toString(),
                            comments: post.commentsCnt,
                            views: post.viewsCnt,
                            likes: post.likesCnt,
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '경제 근육',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '설정',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/mainCommunity');
              break;
            case 1:
              Navigator.pushNamed(context, '/mainMuscle');
              break;
            case 2:
              Navigator.pushNamed(context, '/mainSetting');
              break;
          }
        },
      ),
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
        // view_post_screen.dart로 이동
        Navigator.pushNamed(context, '/viewPost', arguments: {
          'title': title,
          'author': author,
          'time': time,
          'comments': comments,
          'views': views,
          'likes': likes,
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('$time | $author'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.comment, size: 14),
                    const SizedBox(width: 4),
                    Text('$comments'),
                    const SizedBox(width: 16),
                    const Icon(Icons.visibility, size: 14),
                    const SizedBox(width: 4),
                    Text('$views'),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_up, size: 14),
                    const SizedBox(width: 4),
                    Text('$likes'),
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
