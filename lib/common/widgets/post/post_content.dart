import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  final String content;

  const PostContent({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
