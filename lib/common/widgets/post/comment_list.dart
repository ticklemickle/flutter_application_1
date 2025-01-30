import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/common/widgets/commonProgressIndicator.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';
import 'package:flutter_application_1/common/utils/dateTimeUtil.dart';
import 'package:flutter_application_1/providers/view_post_provider.dart';
import 'package:provider/provider.dart';

class CommentList extends StatelessWidget {
  final String postId;
  final FirestoreService firestoreService;

  const CommentList(
      {required this.postId, required this.firestoreService, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewPostProvider>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getCommentsStream(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 300,
            child: const Center(child: CommonProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox(
            height: 300,
            child: const Center(child: Text('첫 댓글을 남겨주세요.')),
          );
        }

        // 댓글 개수 업데이트를 빌드 후 실행하도록 변경
        Future.microtask(() {
          provider.updateCommentCount(snapshot.data!.docs.length);
        });

        return Column(
          children: snapshot.data!.docs.map((doc) {
            return ListTile(
              contentPadding: EdgeInsets.zero, // 좌우 padding 제거
              title: Text(doc['text']),
              subtitle: Text(formatRelativeTime(doc['timestamp'])),
            );
          }).toList(),
        );
      },
    );
  }
}
