import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/commonProgressIndicator.dart';
import 'package:flutter_application_1/providers/view_post_provider.dart';
import 'package:flutter_application_1/common/widgets/post/post_header.dart';
import 'package:flutter_application_1/common/widgets/post/post_content.dart';
import 'package:flutter_application_1/common/widgets/post/post_actions.dart';
import 'package:flutter_application_1/common/widgets/post/comment_list.dart';
import 'package:flutter_application_1/common/widgets/post/comment_input_field.dart';
import 'package:flutter_application_1/data/repositories/firestore_repository.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ViewPostScreen extends StatelessWidget {
  final String postId;

  const ViewPostScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViewPostProvider(
          firestoreService: FirestoreService(), postId: postId),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), // 원하는 아이콘 설정
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로가기 동작
            },
            padding: EdgeInsets.zero, // 마진 제거
            iconSize: 24, // 아이콘 크기 조정
          ),
          titleSpacing: -5.0,
          title: SizedBox(
            height: kToolbarHeight / 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/icon/appBar_logo.png',
                fit: BoxFit.contain, // 비율 유지하면서 크기 조정
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                Share.share('Check out this post: ');
              },
            ),
          ],
        ),
        body: Consumer<ViewPostProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const Center(child: CommonProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostHeader(
                          category: provider.category,
                          title: provider.title,
                          author: provider.author,
                          time: provider.time,
                        ),
                        const SizedBox(height: 16),
                        PostContent(content: provider.content),
                        PostActions(postId: postId),
                        Container(
                          alignment: Alignment.center,
                          child: CommentList(
                            postId: postId,
                            firestoreService: provider.firestoreService,
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
        bottomSheet: CommentInputField(postId: postId),
      ),
    );
  }
}
