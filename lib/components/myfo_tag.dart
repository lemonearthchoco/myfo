import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/themes/myfo_tag_decoration.dart';

class MyfoTag extends StatelessWidget {
  final String tag;

  MyfoTag(this.tag);

  @override
  Widget build(BuildContext context) {
    final customDecorations = Theme.of(context).extension<MyfoTagDecoration>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: customDecorations?.defaultBoxDecoration,
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