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
    double width = 350.0, // 기본값
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // 바깥 클릭 시 닫기
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
          ),
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: leftButtonAction, // 왼쪽 버튼 기능
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: BorderSide(
                                color: MyColors.grey, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
                            ),
                          ),
                          child: Text(
                            leftButtonText,
                            style: const TextStyle(
                              color: MyColors.darkGrey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextButton(
                          onPressed: rightButtonAction, // 오른쪽 버튼 기능
                          style: TextButton.styleFrom(
                            backgroundColor: MyColors.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              side: BorderSide(
                                color: MyColors.mainColor, // 테두리 색상
                                width: 1.0, // 테두리 두께
                              ),
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
