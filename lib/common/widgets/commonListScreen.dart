import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/common/widgets/commonToast.dart';

class CommonListScreen extends StatelessWidget {
  final String title;
  final List<ListItem> items;

  const CommonListScreen({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로가기 동작
            },
            padding: EdgeInsets.zero, // 마진 제거
            iconSize: 24, // 아이콘 크기 조정
          ),
          titleSpacing: -5.0,
          iconTheme: const IconThemeData(color: MyColors.mainFontColor),
          title: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: MyColors.mainFontColor),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.title),
              trailing: item.viewIcon
                  ? const Icon(Icons.arrow_forward_ios, size: 16)
                  : const SizedBox.shrink(),
              onTap: () => _handleItemTap(context, item),
            );
          },
        ),
      ),
    );
  }

  void _handleItemTap(BuildContext context, ListItem item) async {
    if (item.url != null) {
      final Uri url = Uri.parse(item.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        showToast(context, "URL을 열 수 없습니다.");
      }
    } else if (item.onTap != null) {
      item.onTap!(context);
    }
  }
}

class ListItem {
  final String title;
  final String? url;
  final bool viewIcon;
  final void Function(BuildContext)? onTap;

  ListItem({required this.title, this.url, required this.viewIcon, this.onTap});
}
