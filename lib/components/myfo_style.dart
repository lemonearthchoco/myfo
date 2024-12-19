import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_text.dart';

class MyfoStyle {
  static final TextStyle textStyle = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16.0,
    letterSpacing: -0.4,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      alignLabelWithHint: true,
      label: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: MyfoText(
          label,
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 1.2,
        ),
      ),
    );
  }
}
