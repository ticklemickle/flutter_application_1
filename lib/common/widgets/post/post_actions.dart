import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/view_post_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PostActions extends StatelessWidget {
  final String postId;

  const PostActions({required this.postId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ViewPostProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: provider.likesNotifier,
              builder: (context, likes, child) {
                return IconButton(
                  icon: Icon(provider.isLiked
                      ? Icons.thumb_up
                      : Icons.thumb_up_outlined),
                  onPressed: () => provider.toggleLike(),
                );
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: provider.likesNotifier,
              builder: (context, likes, child) {
                return Text('$likes');
              },
            ),
          ],
        ),
        Row(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: provider.commentsNotifier,
              builder: (context, comments, child) {
                return Text('댓글 $comments   ');
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: provider.viewsNotifier,
              builder: (context, views, child) {
                return Text('조회 $views회');
              },
            ),
          ],
        ),
      ],
    );
  }
}
