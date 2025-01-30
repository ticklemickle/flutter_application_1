import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';

class PostHeader extends StatelessWidget {
  final String category;
  final String title;
  final String author;
  final String time;

  const PostHeader({
    required this.category,
    required this.title,
    required this.author,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTag(category),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('$author | $time',
            style: const TextStyle(color: MyColors.subFontColor, fontSize: 14)),
      ],
    );
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: MyColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Text(category, style: const TextStyle(color: MyColors.mainFontColor)),
    );
  }
}
