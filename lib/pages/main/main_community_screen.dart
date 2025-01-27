import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/widgets/commonScaffold.dart';
import 'package:flutter_application_1/pages/community/community_content.dart';
import 'package:flutter_application_1/pages/main/main_muscle_screen.dart';
import 'package:flutter_application_1/pages/main/main_setting_screen.dart';

class MainCommunityScreen extends StatefulWidget {
  const MainCommunityScreen({super.key});

  @override
  _MainCommunityScreenState createState() => _MainCommunityScreenState();
}

class _MainCommunityScreenState extends State<MainCommunityScreen> {
  int _currentIndex = 0;

  final List<String> _titles = ['', '경제 근육 키우기', '설정'];
  final List<TextAlign> _titleAlignments = [
    TextAlign.center,
    TextAlign.center,
    TextAlign.center,
  ];

  // 각 화면 위젯
  final List<Widget> _pages = const [
    CommunityContent(),
    MainMuscleScreen(),
    MainSettingScreen(),
  ];

  // 각 화면별 오른쪽 아이콘
  final List<List<Widget>?> _actions = [
    null, // CommunityContent: AppBar 없음
    null, // 경제 근육: 오른쪽 아이콘 없음
    [
      IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
    ], // 설정: 로그아웃 아이콘
  ];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: _titles[_currentIndex], // 현재 index에 맞는 title 사용
      titleAlignment: _titleAlignments[_currentIndex], // 현재 화면의 정렬 방식
      actions: _actions[_currentIndex], // 현재 화면의 오른쪽 아이콘
      child: IndexedStack(
        index: _currentIndex, // 현재 index에 맞는 화면만 유지
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // index 변경
          });
        },
        selectedItemColor: MyColors.mainDarkColor, // 선택된 아이콘 색상
        unselectedItemColor: MyColors.subFontColor, // 선택되지 않은 아이콘 색상
        backgroundColor: MyColors.mainBackgroundColor, // 배경색상
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '경제 근육',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
