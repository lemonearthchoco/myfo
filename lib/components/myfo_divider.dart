import 'package:flutter/material.dart';

class MyfoDivider extends StatelessWidget {
  const MyfoDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1.0,
      thickness: 3.5,
      color: Color.fromARGB(232, 232, 232, 232),
    );
  }
}