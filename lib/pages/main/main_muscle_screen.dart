import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';
import 'package:flutter_application_1/common/widgets/muscle/muscle_container.dart';

class MainMuscleScreen extends StatelessWidget {
  const MainMuscleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 60),
      child: Column(
        children: [
          MuscleContainer(
            title: "주식",
            subtitle: "자본주의의 꽃",
            cardText: "웹 사이트",
            mainContent1: "Rule 01. 절대로 잃지 마라.",
            mainContent2: "Rule 02. 첫 번재를 잊지 마라",
            subContent: "시장의 동향과 메크로를 이야기합니다.",
            cardImage: "cardImage/stock.png",
            websiteUrl: "https://www.naver.com",
          ),
          const Divider(color: MyColors.grey, thickness: 0.5, height: 1),
          MuscleContainer(
            title: "부동산",
            subtitle: "래버리지 투자의 끝.판.왕",
            cardText: "오픈 채팅방",
            mainContent1: "내 꿈은 내 집 마련",
            mainContent2: "차분히 그리고 천천히",
            subContent: "부동산 공부가 처음이신 분들에게 추천드립니다.",
            cardImage: "cardImage/housing.png",
            websiteUrl: "https://open.kakao.com/o/sfjpbG4f",
          ),
          const Divider(color: MyColors.grey, thickness: 0.5, height: 1),
          MuscleContainer(
            title: "재테크",
            subtitle: "나만의 노하우",
            cardText: "오픈 채팅방",
            mainContent1: "태산도 티끌부터",
            mainContent2: "작지만 큰 노력들",
            subContent: "나도 나누고, 다른 사람 이야기도 들어보기.",
            cardImage: "cardImage/study.png",
          ),
        ],
      ),
    );
  }
}
