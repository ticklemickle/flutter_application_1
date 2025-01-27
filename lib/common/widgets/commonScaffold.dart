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
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: MyColors.grey), // 기본 테두리 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: MyColors.mainlightColor,
                                  width: 2.0), // 입력 중 테두리 색상
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.mainColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.pushNamed(context, '/addPost');
                          },
                          color: Colors.black, // 아이콘 색상
                        ),
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
