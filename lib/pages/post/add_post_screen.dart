import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/widgets/commonDialog.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';
import 'package:go_router/go_router.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? selectedCategory;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final FirestoreService firestoreService =
      FirestoreService(); // FirestoreService 인스턴스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showExitDialog(context);
          },
        ),
        title: const Text(''),
        actions: [
          TextButton(
            onPressed: () {
              _showConfirmDialog(context);
            },
            child: const Text(
              '등록',
              style: TextStyle(color: MyColors.mainDarkColor, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              dropdownColor: Colors.white,
              underline: SizedBox.shrink(),
              value: selectedCategory,
              hint: const Text('게시판 선택 '),
              items: ['부동산', '주식', '코인', '재테크', '기타']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: '제목을 입력하세요',
                border: InputBorder.none,
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요',
                  counterText: '',
                  border: InputBorder.none,
                ),
                maxLength: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    if (titleController.text.isNotEmpty || contentController.text.isNotEmpty) {
      CommonDialog.show(
        context: context,
        title: '게시물 등록을 취소하시겠습니까?',
        leftButtonText: '아니요',
        leftButtonAction: () => Navigator.pop(context),
        rightButtonText: '예',
        rightButtonAction: () {
          context.go('/mainCommunity');
        },
      );
    } else {
      context.go('/mainCommunity');
    }
  }

  void _showConfirmDialog(BuildContext context) {
    if (selectedCategory != null && titleController.text.isNotEmpty) {
      CommonDialog.show(
        context: context,
        title: '$selectedCategory 게시판에 등록하시겠습니까?',
        leftButtonText: '아니요',
        leftButtonAction: () {
          Navigator.pop(context);
        },
        rightButtonText: '예',
        rightButtonAction: () async {
          context.go('/mainCommunity');
          await _addPostToFirestore();
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리와 제목을 입력하세요.')),
      );
    }
  }

  Future<void> _addPostToFirestore() async {
    try {
      await firestoreService.addPost(
        author: '서울 강서구 남자 | user123', // 예시 데이터, 실제로는 사용자 인증 정보 활용
        category: selectedCategory!,
        title: titleController.text,
        content: contentController.text,
        registerTime: DateTime.now(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('게시글을 등록되었습니다.')),
        );
        context.go('/mainCommunity');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록 중 오류가 발생했습니다: $e')),
      );
    }
  }
}
