import 'package:flutter/material.dart';

class MainSettingScreen extends StatelessWidget {
  const MainSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('알림 설정'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 알림 설정 화면 이동
            },
          ),
          ListTile(
            title: const Text('위치 변경'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 위치 변경 화면 이동
            },
          ),
          ListTile(
            title: const Text('계정 관리'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 계정 관리 화면 이동
            },
          ),
          ListTile(
            title: const Text('자주 묻는 질문'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/faqMain');
            },
          ),
          ListTile(
            title: const Text('문의하기'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 문의하기 화면 이동
            },
          ),
        ],
      ),
    );
  }
}
