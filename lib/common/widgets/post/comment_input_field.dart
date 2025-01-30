import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/view_post_provider.dart';

class CommentInputField extends StatefulWidget {
  final String postId;

  const CommentInputField({required this.postId, Key? key}) : super(key: key);

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _commentController = TextEditingController();
  bool isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        isTextNotEmpty = _commentController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewPostProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: '댓글을 남겨주세요.',
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              maxLength: 500,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: isTextNotEmpty
                ? () async {
                    await provider.firestoreService
                        .addComment(widget.postId, _commentController.text);
                    _commentController.clear();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isTextNotEmpty ? MyColors.mainColor : MyColors.grey,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '등록',
              style: TextStyle(
                color: MyColors.mainFontColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
