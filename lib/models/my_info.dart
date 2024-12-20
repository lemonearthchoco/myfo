
class MyInfo {
  static final String name = "my_info";

  final String themeName;

  MyInfo(
      {required this.themeName});

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'themeName': themeName,
    };
  }

  // JSON 역직렬화
  factory MyInfo.fromJson(Map<String, dynamic> json) {
    return MyInfo(
      themeName: json['themeName']
    );
  }
}
