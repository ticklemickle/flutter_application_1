import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/widgets/commonProgressIndicator.dart';
import 'package:flutter_application_1/common/utils/dateTimeUtil.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';

class PostComments extends StatefulWidget {
  final String postId;

  const PostComments({Key? key, required this.postId}) : super(key: key);

  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  final TextEditingController _commentController = TextEditingController();
  late final FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
  }

  @override
  void dispose() {
    _commentController.dispose(); // ✅ 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // StreamBuilder로 데이터를 가져오는 부분을 ListView에서 Column으로 변경하여 스크롤 제거
        StreamBuilder<QuerySnapshot>(
          stream: firestoreService
              .getCommentsStream(widget.postId), // ✅ FirestoreRepository 활용
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CommonProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('첫 댓글을 남겨주세요.'));
            }

            return Column(
              children: snapshot.data!.docs.map((doc) {
                return ListTile(
                  title: Text(doc['text']),
                  subtitle: Text(formatRelativeTime(doc['timestamp'])),
                );
              }).toList(),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: '댓글을 남겨주세요.',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors.mainlightColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  maxLength: 500,
                ),
              ),
              const SizedBox(height: 100, width: 8),
              _buildAddCommentBtn(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddCommentBtn() {
    return ElevatedButton(
      onPressed: () async {
        if (_commentController.text.isNotEmpty) {
          await firestoreService.addComment(
              widget.postId, _commentController.text);
          _commentController.clear();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.mainColor,
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 20), // 버튼 패딩 추가
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게 설정
        ),
      ),
      child: Text(
        '남기기',
        style: TextStyle(
          color: MyColors.mainFontColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
