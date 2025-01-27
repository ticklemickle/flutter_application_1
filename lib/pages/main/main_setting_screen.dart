import 'package:flutter/material.dart';

class MainSettingScreen extends StatelessWidget {
  const MainSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 필요한 동작 추가
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 사용자 정보와 수정 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'adjlsajdk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // my_info_screen.dart로 이동
                    Navigator.pushNamed(context, '/myInfo');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], // 버튼 배경 색상
                    foregroundColor: Colors.black, // 버튼 글자 색상
                  ),
                  child: const Text('수정'),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // 메뉴 리스트
          _buildMenuItem(context, '내 활동'),
          _buildMenuItem(context, '진행 중인 이벤트'),
          _buildMenuItem(context, '공지사항'),
          _buildMenuItem(context, '자주 묻는 질문'),
          _buildMenuItem(context, '약관 및 정책'),
          _buildMenuItem(context, '문의하기'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // 각 메뉴에 대한 동작 추가
          },
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
