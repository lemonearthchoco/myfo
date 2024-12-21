import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/myfo_colors.dart';

class MyfoText extends StatelessWidget {
  final String text; // 표시할 텍스트
  final double fontSize; // 폰트 크기
  final FontWeight fontWeight; // 폰트 굵기
  final Color color; // 텍스트 색상
  final TextAlign textAlign; // 텍스트 정렬
  final String textType;
  final String locale;

  const MyfoText(String this.text,
      {Key? key,
      this.fontSize = 16.0,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black,
      this.textAlign = TextAlign.start,
      this.textType = 'normal',
      this.locale = 'ko'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (locale == 'ko') {
      return Text(
        text,
        style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: fontSize,
            fontWeight: fontWeight,
            // color: color,
            color: MyfoColors.darkDefault,
            letterSpacing: -0.4),
        textAlign: textAlign,
      );
    } else {
      return Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: 0.8),
        textAlign: textAlign,
      );
    }
  }
}
