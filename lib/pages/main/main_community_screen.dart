import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/community/community_content.dart';

class MainCommunityScreen extends StatefulWidget {
  const MainCommunityScreen({Key? key}) : super(key: key);

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
          const CommunityContent(), // 분리된 위젯 호출
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

          if (index == 0) {
            _pageController.jumpToPage(index);
          } else {
            switch (index) {
              case 1:
                Navigator.pushNamed(context, '/mainMuscle').then((_) {
                  setState(() => currentBottomNaviIndex = 0);
                });
                break;
              case 2:
                Navigator.pushNamed(context, '/myInfo').then((_) {
                  setState(() => currentBottomNaviIndex = 0);
                });
                break;
            }
          }
        },
      ),
    );
  }
}
