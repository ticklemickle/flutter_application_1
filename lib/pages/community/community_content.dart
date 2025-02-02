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
  final PageController _pageController = PageController();
  List<ScrollController> _scrollControllers = [];

  int selectedCategoryIndex = 0;
  final List<String> categories = ['부동산', '주식', '코인', '재테크', '기타'];
  List<List<Map<String, dynamic>>> _posts = List.generate(5, (_) => []);
  List<DocumentSnapshot?> _lastDocuments = List.generate(5, (_) => null);
  List<bool> _isLoading = List.generate(5, (_) => false);
  List<bool> _hasMore = List.generate(5, (_) => true);

  @override
  void initState() {
    super.initState();
    _scrollControllers = List.generate(categories.length, (index) {
      final controller = ScrollController();
      controller.addListener(() => _onScroll(index));
      return controller;
    });
    _loadMorePosts(0);
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll(int index) {
    if (_scrollControllers[index].position.pixels >=
            _scrollControllers[index].position.maxScrollExtent - 100 &&
        !_isLoading[index] &&
        _hasMore[index]) {
      print("📢 Loading more posts for category: ${categories[index]}");
      _loadMorePosts(index);
    }
  }

  void _loadMorePosts(int index, {bool reset = false}) async {
    if (_isLoading[index] || !_hasMore[index]) return;

    setState(() => _isLoading[index] = true);

    try {
      final fetchedPosts = await _firestoreRepository.getPosts(
        selectedCategoryIndex: index,
        categories: categories,
        lastDocument: reset ? null : _lastDocuments[index],
        limit: _firestoreRepository.maxPage,
      );

      setState(() {
        if (reset) {
          _posts[index] = fetchedPosts;
        } else {
          _posts[index].addAll(fetchedPosts);
        }

        if (fetchedPosts.isNotEmpty) {
          _lastDocuments[index] = fetchedPosts.last['docRef'];
        }
        _hasMore[index] = fetchedPosts.length >= _firestoreRepository.maxPage;
      });
    } catch (e) {
      print('🔥 게시글 로드 오류: $e');
    }

    setState(() => _isLoading[index] = false);
  }

  void _updateCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });

    if ((index - _pageController.page!.toInt()).abs() > 1) {
      _pageController.jumpToPage(index);
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    if (_posts[index].isEmpty) {
      _loadMorePosts(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategorySelector(),
        const SizedBox(height: 8),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: categories.length,
            onPageChanged: (index) {
              setState(() => selectedCategoryIndex = index);
              if (_posts[index].isEmpty) {
                _loadMorePosts(index);
              }
            },
            itemBuilder: (context, index) {
              return ListView.builder(
                controller: _scrollControllers[index],
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: _posts[index].length + 1,
                itemBuilder: (context, postIndex) {
                  if (postIndex == _posts[index].length) {
                    return _isLoading[index]
                        ? const Center(child: CommonProgressIndicator())
                        : const SizedBox();
                  }

                  final post = _posts[index][postIndex];
                  return InkWell(
                    onTap: () => context.push('/viewPost/${post['id']}'),
                    child: _buildPostItem(
                      title: post['title'] ?? '제목없음',
                      content: post['content'] ?? '',
                      author: post['author'] ?? 'Unknown',
                      time: formatRelativeTime(post['register_time']),
                      comments: post['comments_cnt'] ?? 0,
                      views: post['views_cnt'] ?? 0,
                      likes: post['likes_cnt'] ?? 0,
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
                  minWidth: 50, // 최소 너비
                ),
                alignment: Alignment.center, // 텍스트를 중앙 정렬
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: selectedCategoryIndex == index
                        ? MyColors.mainFontColor // 선택된 상태 글씨 색상
                        : MyColors.subFontColor, // 선택되지 않은 상태 글씨 색상
                    fontSize: 12,
                    fontWeight: selectedCategoryIndex == index
                        ? FontWeight.normal // 선택된 상태
                        : FontWeight.normal, // 기본 상태
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
    required String content,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // 길 경우 "..." 표시
                    ),
                  ),
                  const SizedBox(width: 15), // 간격 조정
                  Text(
                    time,
                    style: const TextStyle(
                        color: MyColors.subFontColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              content.isNotEmpty
                  ? Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: MyColors.subFontColor,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2, // 최대 2줄까지만 표시
                      overflow: TextOverflow.ellipsis, // 초과 시 ... 표시
                    )
                  : const SizedBox.shrink(),
              Text(
                author,
                style:
                    const TextStyle(color: MyColors.subFontColor, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
