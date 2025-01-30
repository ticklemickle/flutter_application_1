import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';

class CommonDialog {
  static void show({
    required BuildContext context,
    required String title, // 제목
    required String leftButtonText, // 왼쪽 버튼 텍스트
    required VoidCallback leftButtonAction, // 왼쪽 버튼 동작
    required String rightButtonText, // 오른쪽 버튼 텍스트
    required VoidCallback rightButtonAction, // 오른쪽 버튼 동작
    double width = 350.0, // 기본값 설정
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // 바깥 클릭 시 닫기
      builder: (context) {
        return Dialog(
          backgroundColor: MyColors.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
          ),
          child: SizedBox(
            width: width, // 원하는 크기로 설정
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: leftButtonAction, // 왼쪽 버튼 기능
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              side: BorderSide.none,
                            ),
                          ),
                          child: Text(
                            leftButtonText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: rightButtonAction, // 오른쪽 버튼 기능
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.cyan[100], // 파란색 계열 배경
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              side: BorderSide.none,
                            ),
                          ),
                          child: Text(
                            rightButtonText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
