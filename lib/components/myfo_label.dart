import 'package:flutter/cupertino.dart';
import 'package:myfo/components/myfo_text.dart';

class MyfoLabel extends StatelessWidget {
  final String label;
  bool optional = false;

  MyfoLabel({required this.label, this.optional = false});

  @override
  Widget build(BuildContext context) {
    if (optional) {
      return Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          // MyfoText("(선택)", fontSize: 14)
        ],
      );
    }
    return Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }
}
