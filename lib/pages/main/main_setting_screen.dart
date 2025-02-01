import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/commonListScreen.dart';
import 'package:go_router/go_router.dart';

class MainSettingScreen extends StatelessWidget {
  const MainSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
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
                context.push('/myInfo');
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
      _buildMenuItem(context, "내 활동", [
        ListItem(title: "작성한 글", viewIcon: true),
        ListItem(title: "작성한 댓글", viewIcon: true),
        ListItem(title: "좋아요 또는 싫어요한 글", viewIcon: true),
      ]),
      _buildMenuItem(context, "진행 중인 이벤트", [
        ListItem(title: "서비스 이용약관", viewIcon: true),
      ]),
      _buildMenuItem(context, "공지사항", [
        ListItem(title: "서비스 이용약관", viewIcon: true),
      ]),
      _buildMenuItem(context, "문의하기", [
        ListItem(title: "서비스 이용약관", viewIcon: true),
      ]),
      _buildMenuItem(context, "약관 및 정책", [
        ListItem(
            title: "개인 정보 수집 및 이용 동의",
            viewIcon: false,
            url:
                "https://superb-nitrogen-81f.notion.site/68fc5d29d52c459e9284af96f2771812?pvs=4"),
        ListItem(
            title: "개인 정보 처리 방침",
            viewIcon: false,
            url:
                "https://superb-nitrogen-81f.notion.site/bedfe131407645a2af183380542b5536?pvs=4"),
        ListItem(
            title: "서비스 이용약관",
            viewIcon: false,
            url:
                "https://superb-nitrogen-81f.notion.site/18d48074a12d80d8ab2cec2977e2ece7?pvs=4"),
      ]),
      _buildMenuItem(context, "자주 묻는 질문", [
        ListItem(title: "개인정보가 노출된 것 같아요!", viewIcon: true),
        ListItem(title: "회원 탈퇴는 어떻게 하나요?", viewIcon: true),
        ListItem(title: "머니 플래너는 누구인가요?", viewIcon: true),
      ]),
    ]);
  }

  Widget _buildMenuItem(
      BuildContext context, String title, List<ListItem> items) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.normal)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CommonListScreen(title: title, items: items)),
        );
      },
    );
  }
}
