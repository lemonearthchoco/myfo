
import 'dart:ui';

class MyInfo {
  static final String name = "my_info";

  final String themeName;
  final String fontFamily;
  final String language;

  MyInfo(
      {required this.themeName, required this.fontFamily, required this.language});

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'themeName': themeName,
      'fontFamily': fontFamily,
      'language': language
    };
  }

  // JSON 역직렬화
  factory MyInfo.fromJson(Map<String, dynamic> json) {
    return MyInfo(
      themeName: json['themeName'],
      fontFamily: json['fontFamily'],
      language: json['language']
    );
  }
}
