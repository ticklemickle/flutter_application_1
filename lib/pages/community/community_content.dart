import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils/DateTimeUtil.dart';

class CommunityContent extends StatefulWidget {
  const CommunityContent({super.key});

  @override
  _CommunityContentState createState() => _CommunityContentState();
}

class _CommunityContentState extends State<CommunityContent> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['전체', '부동산', '주식', '코인', '재테크', '기타'];
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _loadMorePosts(); // 초기 데이터 로드
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 이벤트 처리
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadMorePosts();
    }
  }

  // 게시글 로드 메서드
  Future<void> _loadMorePosts({bool reset = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Query query = FirebaseFirestore.instance.collection('posts').limit(50);

      // 선택된 카테고리 필터 적용
      if (selectedCategoryIndex != 0) {
        final selectedCategory = categories[selectedCategoryIndex];
        query = query.where('category', isEqualTo: selectedCategory);
      }

      // 페이징 처리
      if (!reset && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();
      final fetchedPosts = querySnapshot.docs
          .map((doc) {
            // doc.data()의 타입을 명시적으로 지정
            final data =
                doc.data() as Map<String, dynamic>?; // 데이터가 Map일 경우에만 처리
            if (data != null) {
              return {
                ...data,
                'id': doc.id, // Firestore 문서 ID 추가
              };
            }
            return null; // 데이터가 null일 경우 null 반환
          })
          .where((post) => post != null) // null 값을 필터링
          .cast<Map<String, dynamic>>() // List의 타입을 Map<String, dynamic>으로 변환
          .toList();

      setState(() {
        if (reset) {
          _posts = fetchedPosts; // 초기화 후 새로운 데이터로 교체
        } else {
          _posts.addAll(fetchedPosts); // 기존 데이터에 추가
        }
        _lastDocument =
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
        _hasMore = fetchedPosts.length == 50; // 데이터가 50개 이상일 경우 추가 로드 가능
      });
    } catch (e) {
      print('Error loading posts: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
      _lastDocument = null;
      _hasMore = true;
      _posts.clear();
    });
    _loadMorePosts(reset: true);
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
                    width: 70,
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  selected: selectedCategoryIndex == index,
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      _updateCategory(index);
                    }
                  },
                  showCheckmark: false,
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        // 게시글 리스트
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _posts.length + 1,
            itemBuilder: (context, index) {
              if (index == _posts.length) {
                return _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(); // 로딩 인디케이터
              }

              final post = _posts[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/viewPost',
                      arguments: post['id']);
                },
                child: _buildPostItem(
                  title: post['title'] ?? 'Untitled',
                  author: post['author'] ?? 'Unknown',
                  time: formatTimestamp(post['register_time']),
                  comments: post['comments_cnt'] ?? 0,
                  views: post['views_cnt'] ?? 0,
                  likes: post['likes_cnt'] ?? 0,
                ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      const Icon(Icons.thumb_up, size: 14, color: Colors.grey),
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
    );
  }
}
