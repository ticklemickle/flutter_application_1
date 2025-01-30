import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/widgets/commonProgressIndicator.dart';
import 'package:flutter_application_1/common/utils/DateTimeUtil.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';
import 'package:go_router/go_router.dart';

class CommunityContent extends StatefulWidget {
  const CommunityContent({super.key});

  @override
  _CommunityContentState createState() => _CommunityContentState();
}

class _CommunityContentState extends State<CommunityContent> {
  final FirestoreService _firestoreRepository = FirestoreService();
  final ScrollController _scrollController = ScrollController();

  int selectedCategoryIndex = 0;
  final List<String> categories = ['전체', '부동산', '주식', '코인', '재테크', '기타'];

  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _loadMorePosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoading &&
        _hasMore) {
      print("📢 Loading more posts...");
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts({bool reset = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final fetchedPosts = await _firestoreRepository.getPosts(
        selectedCategoryIndex: selectedCategoryIndex,
        categories: categories,
        lastDocument: reset ? null : _lastDocument,
      );

      setState(() {
        if (reset) {
          _posts = fetchedPosts;
        } else {
          _posts.addAll(fetchedPosts);
        }

        if (fetchedPosts.isNotEmpty) {
          _lastDocument = fetchedPosts.last['docRef']; // 🔥 docRef를 사용
        }

        _hasMore = fetchedPosts.length >= _firestoreRepository.maxPage;
      });
    } catch (e) {
      print('🔥 게시글 로드 오류: $e');
    }

    setState(() => _isLoading = false);
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
        _buildCategorySelector(),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            controller: _scrollController,
            itemCount: _posts.length + 1,
            itemBuilder: (context, index) {
              if (index == _posts.length) {
                return _isLoading
                    ? const Center(child: CommonProgressIndicator())
                    : const SizedBox();
              }

              final post = _posts[index];
              return InkWell(
                onTap: () => context.push('/viewPost/${post['id']}'),
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

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Row(
        children: List.generate(categories.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Container(
                constraints: const BoxConstraints(
                  minHeight: 20, // 최소 높이
                  minWidth: 60, // 최소 너비
                ),
                alignment: Alignment.center, // 텍스트를 중앙 정렬
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: selectedCategoryIndex == index
                        ? MyColors.mainFontColor // 선택된 상태 글씨 색상
                        : MyColors.subFontColor, // 선택되지 않은 상태 글씨 색상
                    fontSize: 14,
                    fontWeight: selectedCategoryIndex == index
                        ? FontWeight.bold // 선택된 상태는 Bold
                        : FontWeight.normal, // 기본 상태는 Normal
                  ),
                ),
              ),
              selected: selectedCategoryIndex == index,
              selectedColor: MyColors.mainColor,
              backgroundColor: MyColors.lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              side: BorderSide.none, // 테두리 제거
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
                style:
                    const TextStyle(color: MyColors.subFontColor, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.comment,
                          size: 14, color: MyColors.subFontColor),
                      const SizedBox(width: 4),
                      Text('$comments'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      const Icon(Icons.visibility,
                          size: 14, color: MyColors.subFontColor),
                      const SizedBox(width: 4),
                      Text('$views'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up,
                          size: 14, color: MyColors.subFontColor),
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
        const Divider(color: MyColors.lightGrey, thickness: 0.5, height: 1),
      ],
    );
  }
}
