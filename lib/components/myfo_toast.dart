import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/myfo_colors.dart';

enum MessageLevel { SUCCESS, WARNING, ERROR }

class MyfoToast extends StatelessWidget {
  final String message;
  final MessageLevel level;

  MyfoToast({required this.message, this.level = MessageLevel.SUCCESS});

  _getToastIcon() {
    switch (level) {
      case MessageLevel.SUCCESS:
        return Icon(CupertinoIcons.check_mark_circled_solid,
            color: MyfoColors.primaryLight);
      case MessageLevel.WARNING:
        return Icon(CupertinoIcons.check_mark_circled_solid,
            color: Colors.lightGreenAccent);
      case MessageLevel.ERROR:
        return Icon(CupertinoIcons.exclamationmark_circle,
            color: Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 140,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getToastIcon(),
            const SizedBox(
              width: 10,
            ),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
