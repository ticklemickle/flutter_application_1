import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';

class CommonScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final TextAlign titleAlignment;
  final List<Widget>? actions;
  final bool isSearchBarVisible;

  const CommonScaffold({
    super.key,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.titleAlignment = TextAlign.center,
    this.actions,
    this.isSearchBarVisible = false, // 기본값: 검색바 비활성화
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainBackgroundColor, // 배경색
      appBar: AppBar(
        title: isSearchBarVisible
            ? null // 검색바 표시 시 기본 타이틀 제거
            : Text(
                title ?? '',
                textAlign: titleAlignment,
                style: const TextStyle(color: MyColors.mainFontColor),
              ),
        actions: actions,
        bottom: isSearchBarVisible
            ? PreferredSize(
                preferredSize: const Size.fromHeight(70), // 검색바 높이
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '검색',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.pushNamed(context, '/addPost');
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null, // 검색바 비활성화 시 bottom 제거
        backgroundColor: MyColors.mainBackgroundColor, // AppBar 배경색
        iconTheme: const IconThemeData(color: MyColors.mainFontColor),
        bottomOpacity: 1.0, // 투명도
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
