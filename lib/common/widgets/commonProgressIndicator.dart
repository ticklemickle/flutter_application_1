import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/themes/colors.dart';

class CommonProgressIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CommonProgressIndicator({
    Key? key,
    this.color = MyColors.mainDarkColor, // 기본 색상 지정
    this.size = 40.0, // 기본 크기 지정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 4.0, // 원의 두께 조정
        ),
      ),
    );
  }
}
