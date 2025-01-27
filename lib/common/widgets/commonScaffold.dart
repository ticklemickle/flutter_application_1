import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';

class CommonScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final TextAlign titleAlignment; // 추가: 제목 정렬 옵션
  final List<Widget>? actions; // 추가: 오른쪽 아이콘

  const CommonScaffold({
    super.key,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.titleAlignment = TextAlign.center, // 기본값: 가운데 정렬
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainBackgroundColor,
      appBar: title != ''
          ? AppBar(
              title: Text(
                title!,
                textAlign: titleAlignment,
                style: const TextStyle(color: MyColors.mainFontColor),
              ),
              actions: actions, // 오른쪽 아이콘
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1), // Divider 높이
                child: Container(
                  color: Colors.grey[300], // 옅은 회색 구분선
                  height: 1,
                ),
              ),
              backgroundColor: MyColors.mainBackgroundColor, // AppBar 배경색
              iconTheme:
                  const IconThemeData(color: MyColors.mainFontColor), // 아이콘 색상
            )
          : null,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
