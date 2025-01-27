import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/community/community_content.dart';
import 'package:flutter_application_1/pages/main/main_muscle_screen.dart';
import 'package:flutter_application_1/pages/main/main_setting_screen.dart';

class MainCommunityScreen extends StatefulWidget {
  const MainCommunityScreen({super.key});

  @override
  _MainCommunityScreenState createState() => _MainCommunityScreenState();
}

class _MainCommunityScreenState extends State<MainCommunityScreen> {
  int currentBottomNaviIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentBottomNaviIndex = index;
          });
        },
        children: [
          const CommunityContent(),
          const MainMuscleScreen(),
          const MainSettingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomNaviIndex,
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
        onTap: (index) {
          if (index == currentBottomNaviIndex) return;
          _pageController.jumpToPage(index);
          setState(() => currentBottomNaviIndex = index);
        },
      ),
    );
  }
}
