import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showExitDialog();
          },
        ),
        title: const Text(''),
        actions: [
          TextButton(
            onPressed: () {
              _showConfirmDialog();
            },
            child: const Text(
              '등록',
              style: TextStyle(color: Colors.blue, fontSize: 16),
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
              value: selectedCategory,
              hint: const Text('게시판 선택'),
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
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('해당 창에서 나가시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog 닫기
              Navigator.pushReplacementNamed(
                  context, '/mainCommunity'); // 메인 커뮤니티로 이동
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    if (selectedCategory != null && titleController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('$selectedCategory 게시판에 등록하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _addPostToFirestore(); // Firestore 저장
              },
              child: const Text('예'),
            ),
          ],
        ),
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
        author: '서울 강남구 여자 | user123', // 예시 데이터, 실제로는 사용자 인증 정보 활용
        category: selectedCategory!,
        title: titleController.text,
        content: contentController.text,
        registerTime: DateTime.now(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('게시글이 성공적으로 등록되었습니다.')),
        );
        Navigator.pushReplacementNamed(context, '/mainCommunity');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록 중 오류가 발생했습니다: $e')),
      );
    }
  }
}
