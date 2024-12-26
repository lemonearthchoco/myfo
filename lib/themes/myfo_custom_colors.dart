import 'package:flutter/material.dart';

class MyfoCustomColors extends ThemeExtension<MyfoCustomColors> {
  static const Color darkDefault = Color(0xFF332929);
  static const Color darkDefaultLight = Color(0xFF6b6161);

  @override
  MyfoCustomColors copyWith() {
    return MyfoCustomColors();
  }

  @override
  MyfoCustomColors lerp(ThemeExtension<MyfoCustomColors>? other, double t) {
    if (other is! MyfoCustomColors) return this;
    return MyfoCustomColors();
  }
}
