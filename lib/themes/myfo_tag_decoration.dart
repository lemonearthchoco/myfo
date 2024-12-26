import 'package:flutter/material.dart';
import 'package:myfo/themes/myfo_colors.dart';

class MyfoTagDecoration extends ThemeExtension<MyfoTagDecoration> {
  final BoxDecoration? defaultBoxDecoration;

  const MyfoTagDecoration({this.defaultBoxDecoration});

  @override
  MyfoTagDecoration copyWith({BoxDecoration? defaultBoxDecoration}) {
    return MyfoTagDecoration(
      defaultBoxDecoration: defaultBoxDecoration ?? this.defaultBoxDecoration,
    );
  }

  @override
  MyfoTagDecoration lerp(ThemeExtension<MyfoTagDecoration>? other, double t) {
    if (other is! MyfoTagDecoration) return this;
    return MyfoTagDecoration(
      defaultBoxDecoration: BoxDecoration.lerp(
          defaultBoxDecoration, other.defaultBoxDecoration, t),
    );
  }
}
