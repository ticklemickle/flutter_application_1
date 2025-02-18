import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:go_router/go_router.dart';

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
        scrolledUnderElevation: 0,
        title: isSearchBarVisible
            ? buildSearchBar(context) // 검색바를 별도 메서드로 분리
            : Text(
                title ?? '',
                textAlign: titleAlignment,
                style: const TextStyle(
                    fontSize: 18, color: MyColors.mainFontColor),
              ),
        actions: actions,
        backgroundColor: MyColors.mainBackgroundColor, // AppBar 배경색
        iconTheme: const IconThemeData(color: MyColors.mainFontColor),
        bottomOpacity: 1.0, // 투명도
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final double ADD_POST_BTN_SIZE = 35;

    return PreferredSize(
      preferredSize: const Size.fromHeight(70), // 검색바 높이
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색',
                  counterText: '',
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: MyColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: MyColors.mainlightColor,
                      width: 2.0,
                    ),
                  ),
                ),
                maxLength: 100,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                context.push('/addPost');
              },
              child: Container(
                width: ADD_POST_BTN_SIZE,
                height: ADD_POST_BTN_SIZE,
                decoration: BoxDecoration(
                  color: MyColors.mainColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.transparent),
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: const Stack(
                      children: [
                        Icon(Icons.add, size: 30, color: MyColors.shadowGrey),
                        Positioned(
                            left: 1,
                            top: 1,
                            child:
                                Icon(Icons.add, size: 30, color: Colors.white)),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
