import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/widgets/commonToast.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqListScreen extends StatefulWidget {
  final String title;

  const FaqListScreen({super.key, required this.title});

  @override
  _FaqListScreenState createState() => _FaqListScreenState();
}

class _FaqListScreenState extends State<FaqListScreen> {
  // 초기 5개의 질문과 답변
  final List<Map<String, String>> faqData = [
    {
      'question': '티끌미끌은 어떤 서비스인가요?',
      'answer': '가장 편하게 돈 이야기를 나눌 수 있는 공간을 제공하는 서비스 입니다.'
    },
    {
      'question': '튜터는 누구인가요?',
      'answer':
          '튜터는 티끌미끌에서 검증하고 확인한 각 분야 금융 전문가 분들 입니다. 검증된 전문가에게 안전하게 궁금한 점을 물어보세요.'
    },
    {
      'question': '주소는 실제로 살고 있는 곳을 작성해야 하나요?',
      'answer': '아닙니다. 거주지가 아니더라도 접근 편리한 장소로 설정 부탁드립니다.'
    },
    {
      'question': '서비스 이용 중 사이버 피해를 받았습니다.',
      'answer': '피해 받은 사실에 대한 구체적인 시간과 캡쳐한 화면, 상대방의 아이디를 명시하여 고객운영팀에 연락 부탁드립니다.'
    },
    {
      'question': '작성한 글이나 댓글을 삭제하고 싶습니다.',
      'answer': '현재는 삭제 및 편집 기능을 제공하고 있지 않습니다. 개별적으로 고객운영팀에 문의 부탁드립니다.'
    },
    {
      'question': '본 서비스에서 주식 또는 코인 리딩방을 운영하나요?',
      'answer':
          '본 서비스는 주식 또는 코인 리딩방을 운영하지 않습니다. 불법적인 서비스 이용 및 도용 현황을 확인하시는 경우, 고객운영팀에 신고 부탁드립니다.'
    },
    {
      'question': '어떻게 하면 튜터가 될 수 있나요?',
      'answer': '튜터는 상시 모집 중에 있습니다. 간단한 프로필을 작성하여 고객운영팀에 연락 부탁드립니다.'
    },
    {
      'question': '서비스 이용하는데 비용이 드나요?',
      'answer':
          '본 서비스는 무료 서비스 입니다. 경제 근육 프로그램을 참여하는 경우에만 별도의 스터디 참여 비용 및 상담 비용이 있을 수 있습니다.'
    },
  ];

  bool showMore = false; // '더보기' 상태 관리
  String customerUrl = "https://open.kakao.com/o/sSDxZ1cg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18, color: MyColors.mainFontColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          iconSize: 24,
        ),
        titleSpacing: -5.0,
      ),
      body: ListView(
        children: [
          // FAQ 리스트
          ...faqData.take(showMore ? faqData.length : 5).map((faq) {
            return _buildFaqItem(
              question: faq['question']!,
              answer: faq['answer']!,
            );
          }).toList(),
          const SizedBox(height: 30),
          // '더보기' 버튼
          if (faqData.length > 5)
            Center(
              child: Visibility(
                visible: !showMore, // showMore가 true일 때만 버튼이 보이게 설정
                child: SizedBox(
                  width: 200,
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: MyColors.lightGrey,
                    ),
                    child: Text(
                      '더 보기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // 글씨를 bold 처리
                        color: MyColors.darkGrey, // 글씨를 black으로 설정
                      ),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),
          // 고객센터 링크
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              color: MyColors.mainlightestColor, // 배경을 옅은 하늘색으로 설정
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24시간, 365일 편하게 물어보세요.',
                      style: TextStyle(
                        color: MyColors.mainFontColor,
                      ),
                    ),
                    Text(
                      '고객운영팀이 언제나 도와드리겠습니다.',
                      style: TextStyle(
                        color: MyColors.mainFontColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(customerUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          showToast(context,
                              "ticklemickle20@gmail.com 으로 연락 부탁드립니다.;l");
                        }
                      },
                      child: Text(
                        '문의하기',
                        style: TextStyle(
                          color: MyColors.linkFontColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero, // Padding 제거
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Q.   ",
                style: TextStyle(
                  color: MyColors.mainDarkColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "$question",
                style: TextStyle(
                  color: MyColors.mainFontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left, // 좌측 정렬
        ),
        iconColor: Colors.grey[400], // 화살표 아이콘 색상 옅은 회색 처리
        // 테두리 없애기 위한 수정
        shape: Border.all(color: Colors.transparent), // 테두리 없애기
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 7, 25, 20),
            child: Align(
              alignment: Alignment.centerLeft, // 좌측 정렬을 명시적으로 설정
              child: Text(
                answer,
                style: TextStyle(
                  color: MyColors.subFontColor, // answer 글씨 색상 grey 처리
                ),
                textAlign: TextAlign.left, // 좌측 정렬
              ),
            ),
          ),
        ],
      ),
    );
  }
}
