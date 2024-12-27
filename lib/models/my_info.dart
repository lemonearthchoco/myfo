
class MyInfo {
  static final String name = "my_info";

  final String themeName;
  final String fontFamily;

  MyInfo(
      {required this.themeName, required this.fontFamily});

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'themeName': themeName,
      'fontFamily': fontFamily
    };
  }

  // JSON 역직렬화
  factory MyInfo.fromJson(Map<String, dynamic> json) {
    return MyInfo(
      themeName: json['themeName'],
      fontFamily: json['fontFamily']
    );
  }
}
