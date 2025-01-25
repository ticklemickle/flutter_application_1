import 'package:flutter/material.dart';

class MainCommunityScreen extends StatefulWidget {
  const MainCommunityScreen({Key? key}) : super(key: key);

  @override
  _MainCommunityScreenState createState() => _MainCommunityScreenState();
}

class _MainCommunityScreenState extends State<MainCommunityScreen> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['부동산', '주식', '코인', '재테크'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 게시글 작성 화면으로 이동
              Navigator.pushNamed(context, '/addPost');
            },
          ),
        ],
      ),
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
                    label: Text(categories[index]),
                    selected: selectedCategoryIndex == index,
                    selectedColor: Colors.blue,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // 게시글 리스트
          Expanded(
            child: ListView(
              children: [
                _buildPostItem(
                  title: '힐리오시티 구매 타이밍 일까…?',
                  author: '경기도 고양시 남자 | adlsjsjdk',
                  time: '2025.01.13',
                  comments: 10,
                  views: 32,
                  likes: 100,
                ),
                _buildPostItem(
                  title: '부동산 저점은 언제일까요',
                  author: '서울 강남구 여자 | VUOP',
                  time: '2시간 전',
                  comments: 10,
                  views: 32,
                  likes: 100,
                ),
                _buildPostItem(
                  title: '이젠 그만 포기해야 할 것 같아요',
                  author: '경남 아산시 남자 | qwe123',
                  time: '56분 전',
                  comments: 10,
                  views: 32,
                  likes: 100,
                ),
              ],
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
            label: '경제 분석',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '내 정보',
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
