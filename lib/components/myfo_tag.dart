import 'package:flutter/cupertino.dart';
import 'package:myfo/components/myfo_text.dart';

class MyfoTag extends StatelessWidget {
  final String tag;

  MyfoTag(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(230, 230, 230, 230), // 파스텔톤 배경색
        borderRadius: BorderRadius.circular(20), // 둥근 모서리
        border: Border.all(color: Color.fromARGB(230, 230, 230, 230)), // 테두리
      ),
      child: Text(
        tag,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12
        )
      ),
    );
  }
}